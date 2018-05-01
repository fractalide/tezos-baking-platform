killall tezos-client
killall tezos-node
rm -rf sandbox
mkdir -p sandbox

tezos-sandbox-network.sh
bootstrap-env.sh
bootstrap-alphanet.sh

obsidian-scripts/monitored-bakers.sh bootstrap0 bootstrap1 bootstrap2 bootstrap3 bootstrap4

tezos-sandbox-client.sh gen keys "account1"
tezos-sandbox-client.sh transfer 1000000 from "bootstrap1" to "account1"
tezos-sandbox-client.sh gen keys "account2"
tezos-sandbox-client.sh transfer 1000000 from "bootstrap2" to "account2"
tezos-sandbox-client.sh gen keys "account3"
tezos-sandbox-client.sh transfer 1000000 from "bootstrap3" to "account3"
tezos-sandbox-client.sh gen keys "account4"
tezos-sandbox-client.sh transfer 1000000 from "bootstrap4" to "account4"
tezos-sandbox-client.sh gen keys "account5"
tezos-sandbox-client.sh transfer 1000000 from "bootstrap0" to "account5"

cat < ./tezos-loadtest/config.json \
    | jq '._client_exe = $client' --arg client "$(which tezos-sandbox-client.sh)" \
    > sandbox/loadtest-config.json

tezos-sandbox-client.sh bootstrapped
sleep 3

tezos-loadtest sandbox/loadtest-config.json

