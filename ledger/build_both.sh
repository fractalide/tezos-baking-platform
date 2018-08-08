#!/usr/bin/env bash
set -eu
set -o pipefail
cd "$(dirname "$0")"

{
    echo "Building wallet app..."
    BAKING_APP='' ./build.sh
    cp ledger-app/bin/app.hex wallet.hex
    size ledger-app/bin/app.elf
    echo "Building baking app..."
    BAKING_APP=Y ./build.sh
    cp ledger-app/bin/app.hex baking.hex
    size ledger-app/bin/app.elf
} 2>&1 | {
    if [ "${1:-X}" = "all" ]; then
        cat
    else
        grep -e Error -e error -e '^src/.*warning:' -e app.elf -e filename -e Building || :
    fi
}
tar czf release.tar.gz wallet.hex baking.hex
echo "Done! release.tar.gz ready for release."
