#!/bin/sh
set -eux

cd "$(dirname "$0")"/..
scripts/sandbox-nodes.sh
bootstrap-baking.sh
tezos-sandbox-client.sh import secret key my-ledger "ledger://tz1VasatP7zmHDxPeBn97YoSFowXLdsBAdW9/0'/0'"
