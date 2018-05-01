#!/usr/bin/env bash

for i in $(seq 1 "$#") ; do
    echo "LAUNCH BAKER:" "${!i}"
    tezos-bake-monitor --port $((9800 + i)) --rpchost 127.0.0.1:$((18731 + i)) -- `which tezos-sandbox-client.sh` --port $((18731 + i)) launch daemon "${!i}" -B -E -D &
done


