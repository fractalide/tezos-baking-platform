#!/usr/bin/env bash
set -euo pipefail
#TODO: Fully nixify this build

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$DIR"

{
    echo 8004000009028000002c800006c1
    echo -n 8004810081
    cat
} | nix-shell ledger-blue-shell.nix --pure --run 'python -m ledgerblue.runScript --apdu'
