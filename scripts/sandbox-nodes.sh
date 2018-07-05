#!/usr/bin/env bash
set -eux

killall tezos-client || :
killall tezos-node || :
rm -rf sandbox

mkdir -p sandbox
tezos-sandbox-network.sh
sleep 5
bootstrap-env.sh
bootstrap-alphanet.sh
