#!/usr/bin/env bash
set -euo pipefail

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$DIR"

{
    echo -n 8006810004
    if [ "${1:-}X" = X ]; then
        cat
    else
        echo "$1"
    fi
} | nix-shell ledger-blue-shell.nix --pure --run 'python -m ledgerblue.runScript --apdu'
