#!/bin/sh
set -eux

cd "$(dirname "$0")"/..
scripts/sandbox-nodes.sh
bootstrap-baking.sh
tezos-sandbox-client.sh import secret key my-ledger "ledger://major-squirrel-thick-hedgehog/ed25519/0'/0'"
tezos-sandbox-client.sh transfer 1000000 from bootstrap0 to my-ledger
