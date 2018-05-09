#!/usr/bin/env bash

for i in $(seq 1 "$#") ; do
    echo "LAUNCH BAKER:" "${!i}"
    tezos-bake-monitor --port $((9800 + i)) --rpchost 127.0.0.1:$((18731 + i)) --client `which tezos-sandbox-client.sh` --identity "${!i}" &
    sleep 1
done
