#!/bin/sh
set -eux

cd "$(dirname "$0")"/..
scripts/sandbox-nodes.sh
bootstrap-baking.sh
tezos-sandbox-client.sh import secret key my-ledger "ledger://tz1VasatP7zmHDxPeBn97YoSFowXLdsBAdW9/0'/0'" --force
tezos-sandbox-client.sh transfer 1000000 from bootstrap0 to my-ledger
