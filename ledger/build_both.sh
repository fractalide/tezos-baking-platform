#!/bin/sh
set -eu
cd "$(dirname "$0")"

BAKING_APP='' ./build.sh
cp ledger-app/bin/app.hex wallet.hex
BAKING_APP=Y ./build.sh
cp ledger-app/bin/app.hex baking.hex
