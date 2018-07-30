#!/usr/bin/env bash
set -eu
set -o pipefail
cd "$(dirname "$0")"

{
    BAKING_APP='' ./build.sh
    cp ledger-app/bin/app.hex wallet.hex
    BAKING_APP=Y ./build.sh
    cp ledger-app/bin/app.hex baking.hex
} 2>&1 | grep -e Error -e error -e '^src/.*warning:'
tar czf release.tar.gz wallet.hex baking.hex
echo "Done! release.tar.gz ready for release."
