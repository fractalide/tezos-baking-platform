#!/usr/bin/env bash
set -eux
killall tezos-client || :
killall tezos-node ||:
rm -rf sandbox
mkdir -p sandbox

fail() {
    echo "FAILURE! FAILURE!"
    false
}

tezos-sandbox-network.sh || fail
sleep 5
bootstrap-env.sh || fail
bootstrap-alphanet.sh || fail

monitored-bakers.sh bootstrap0 bootstrap1

tezos-sandbox-client.sh import ledger secret key my-ledger ed25519
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

op1=$(attempt tezos-sandbox-client.sh transfer 2000001 from bootstrap0 to my-ledger |
    extract_operation_id)
op2=$(attempt tezos-sandbox-client.sh transfer 2000000 from bootstrap1 to my-ledger |
    extract_operation_id)
echo $op1 $op2

attempt tezos-sandbox-client.sh transfer 1 from my-ledger to bootstrap0
attempt tezos-sandbox-client.sh set delegate for my-ledger to my-ledger

exec tezos-sandbox-client.sh launch daemon my-ledger -B -E -D
#exec tezos-bake-monitor --port 9803 --rpchost 127.0.0.1:18733 --client `which tezos-sandbox-client.sh` --identity my-ledger
