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

tezos-sandbox-client.sh -A 127.0.0.1 -P 18731 launch daemon bootstrap0 -B -E -D &
tezos-sandbox-client.sh -A 127.0.0.1 -P 18731 launch daemon bootstrap1 -B -E -D &
tezos-sandbox-client.sh -A 127.0.0.1 -P 18731 launch daemon bootstrap2 -B -E -D &
tezos-sandbox-client.sh -A 127.0.0.1 -P 18731 launch daemon bootstrap3 -B -E -D &

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
  tezos-sandbox-client.sh -A 127.0.0.1 -P $(((i - 1) + 18731)) launch daemon "account${i}" -B -E -D -M --monitor-port $((17730+$i)) &
  sleep 1
done

cat < ./tezos-loadtest/config.json \
    | jq '._client_exe = $client' --arg client "$(which tezos-sandbox-client.sh)" \
    > sandbox/loadtest-config.json

tezos-sandbox-client.sh bootstrapped

# don't start the load test until some progress has been made by the bootstrap bakers.
while [ 3 -gt "$(tezos-sandbox-client.sh rpc call /blocks/head with '{}' | jq '.level')" ] ; do sleep 1 ; done


tezos-loadtest sandbox/loadtest-config.json

