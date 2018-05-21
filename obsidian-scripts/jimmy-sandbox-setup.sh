#!/usr/bin/env bash
set -eux

killall tezos-client || :
killall tezos-node ||:
rm -rf sandbox

mkdir -p sandbox
tezos-sandbox-network.sh || fail
sleep 5
bootstrap-env.sh || fail
bootstrap-alphanet.sh || fail
