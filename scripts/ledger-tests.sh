#!/usr/bin/env bash
set -eux

cd "$(dirname "$0")"/..
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

echo "Please start out with ledger in baking app"
sleep 5
attempt tezos-sandbox-client.sh set delegate for my-ledger to my-ledger

echo "Confirm that baking app rejects each of the following attempts, then switch to wallet app"
sleep 5
attempt tezos-sandbox-client.sh transfer 12 from my-ledger to bootstrap1
echo "Switch back to baking app to confirm that this will reject, then use wallet app to sign"
sleep 5
attempt tezos-sandbox-client.sh originate account original for my-ledger transferring 40 from my-ledger --delegatable
echo "Switch back to baking app to confirm that this will reject, then use wallet app to sign"
sleep 5
attempt tezos-sandbox-client.sh transfer 15 from original to bootstrap1
echo "Switch back to baking app to confirm that this will reject, then use wallet app to sign"
sleep 5
attempt tezos-sandbox-client.sh transfer 13 from my-ledger to original
echo "Switch back to baking app to confirm that this will reject, then use wallet app to sign"
sleep 5
attempt tezos-sandbox-client.sh set delegate for original to my-ledger
echo "Switch back to baking app to confirm that this will reject, then use wallet app to sign"
sleep 5
attempt tezos-sandbox-client withdraw delegate from my-ledger
echo "Switch back to baking app to confirm that this will reject, then use wallet app to sign"
attempt tezos-sandbox-client.sh set delegate for my-ledger to my-ledger --fee 1

echo "Switch back to baking app"
sleep 5
attempt tezos-sandbox-client.sh set ledger high water mark for 'ledger://tz1VasatP7zmHDxPeBn97YoSFowXLdsBAdW9/' to 10000
attempt tezos-sandbox-client.sh get ledger high water mark for 'ledger://tz1VasatP7zmHDxPeBn97YoSFowXLdsBAdW9/'
attempt tezos-sandbox-client.sh set ledger high water mark for 'ledger://tz1VasatP7zmHDxPeBn97YoSFowXLdsBAdW9/' to 0
attempt tezos-sandbox-client.sh get ledger high water mark for 'ledger://tz1VasatP7zmHDxPeBn97YoSFowXLdsBAdW9/'

tezos-sandbox-baker-alpha.sh run with local node sandbox/node-1 my-ledger & pid=$!
tezos-sandbox-endorser-alpha.sh run my-ledger & pid2=$!
wait $pid $pid2
