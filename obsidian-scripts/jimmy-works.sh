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
    nix-shell -A sandbox --run obsidian-scripts/jimmy-works-inner.sh \
        --argstr time_between_blocks '[1,1]' \
        --argstr max_peer_id 2 || echo "FAILED"
} 2>&1 | tee $LOG_FILE | grep -i -e ledger -e injected -e client & pid=$!

transcript() {
    kill $pid || :
    ps aux | grep $LOG_FILE | awk '{ print $2 }' | xargs kill || :
    sleep 1
    printf >&2 'Transcript available in: %s\n' "$LOG_FILE"
}
trap transcript SIGINT

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
