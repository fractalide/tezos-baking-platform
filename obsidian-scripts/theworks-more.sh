#!/usr/bin/env bash
set +x
killall tezos-client
killall tezos-node
rm -rf sandbox
mkdir -p sandbox

tezos-sandbox-network.sh
sleep 15
bootstrap-env.sh
bootstrap-alphanet.sh

obsidian-scripts/monitored-bakers.sh bootstrap0 bootstrap1 bootstrap2 bootstrap3 bootstrap4

tezos-sandbox-client.sh gen keys "account1"
tezos-sandbox-client.sh transfer 1000000 from "bootstrap1" to "account1"
tezos-sandbox-client.sh gen keys "account2"
tezos-sandbox-client.sh transfer 1000 from "bootstrap2" to "account2"
tezos-sandbox-client.sh gen keys "account3"
tezos-sandbox-client.sh transfer 400 from "bootstrap3" to "account3"
tezos-sandbox-client.sh gen keys "account4"
tezos-sandbox-client.sh transfer 100 from "bootstrap4" to "account4"
tezos-sandbox-client.sh gen keys "account5"
tezos-sandbox-client.sh transfer 50 from "bootstrap0" to "account5"

for i in $(seq 1 5) ; do
  echo "LAUNCH BAKER: account${i} ON PORT $((9810 + i))"
  tezos-sandbox-client.sh set delegate for "account${i}" to "account${i}"
  tezos-bake-monitor --port $((9810 + i)) --rpchost 127.0.0.1:$((18731 + i)) --client `which tezos-sandbox-client.sh` --identity "account${i}" &
  sleep 1
done

cat < ./tezos-loadtest/config.json \
    | jq '._client_exe = $client' --arg client "$(which tezos-sandbox-client.sh)" \
    > sandbox/loadtest-config.json

tezos-sandbox-client.sh bootstrapped

# don't start the load test until some progress has been made by the bootstrap bakers.
while [ 3 -gt "$(tezos-sandbox-client.sh rpc call /blocks/head with '{}' | jq '.level')" ] ; do sleep 1 ; done


tezos-loadtest sandbox/loadtest-config.json

