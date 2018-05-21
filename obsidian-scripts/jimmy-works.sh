#!/bin/sh
set -eu
cd "$(dirname "$0")"
cd ..
mkdir -p LOGS
LOG_FILE=LOGS/LOG.$(date +%s)
echo $(pwd)/$LOG_FILE
echo "$LOG_FILE contains full transcript, selected portions follow:"
{
    set -eux
    obsidian-scripts/jimmy-sandbox.sh --run obsidian-scripts/jimmy-works-inner.sh ||
        echo "FAILED!"
} 2>&1 | tee $LOG_FILE | grep -i -e ledger -e injected -e client & pid=$!

transcript() {
    sleep 1
    printf >&2 'Transcript available in: %s\n' "$LOG_FILE"
}

interrupted() {
    kill $pid || :
    transcript
}

trap interrupted INT

while true; do
    sleep 10
    mtime=$(stat -c %Y $LOG_FILE)
    now=$(date +%s)
    diff=$(expr $now - $mtime) || :
    if [ $diff -gt 10 ]; then
        printf >&2 '\e[31mERROR: \e[0mBaking has stalled out. Please re-run.\n'
        transcript
    fi
    if ! kill -0 $pid; then
        printf >&2 '\e[31mERROR: \e[0mjimmy-works-inner.sh script failed.\n'
        transcript
        false
    fi
done
