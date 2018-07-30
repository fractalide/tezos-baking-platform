#!/usr/bin/env bash
set -eux

cd "$(dirname "$0")"/..
echo "Please start out with ledger in baking app"
if [ "X${1:-}" != "Xexisting" ]; then
    scripts/sandbox-nodes.sh
fi

bootstrap-baking.sh

tezos-sandbox-client.sh import secret key my-ledger "ledger://tz1VasatP7zmHDxPeBn97YoSFowXLdsBAdW9/0'/0'"
attempt() {
    while ! "$@"; do
        echo 'Failed'
        sleep 3
    done
    sleep 2
}
extract_operation_id() {
    tail -n1 | cut -f2 -d"'"
}

attempt tezos-sandbox-client.sh transfer 2000000 from bootstrap0 to my-ledger
attempt tezos-sandbox-client.sh transfer 2000001 from bootstrap1 to my-ledger

attempt tezos-sandbox-client.sh set delegate for my-ledger to my-ledger

echo "Switch to transaction app"
sleep 5
attempt tezos-sandbox-client.sh transfer 12 from my-ledger to bootstrap1
attempt tezos-sandbox-client.sh originate account original for my-ledger transferring 40 from my-ledger --delegatable
attempt tezos-sandbox-client.sh transfer 15 from original to bootstrap1
attempt tezos-sandbox-client.sh transfer 13 from my-ledger to original
attempt tezos-sandbox-client.sh set delegate for original to my-ledger

echo "Switch back to baking app"
sleep 5
attempt ledger/reset.sh 00000000 # Reset high water mark

exec tezos-sandbox-baker-alpha.sh run with local node sandbox/node-1 my-ledger
#exec tezos-bake-monitor --port 9803 --rpchost 127.0.0.1:18733 --client `which tezos-sandbox-client.sh` --identity my-ledger
