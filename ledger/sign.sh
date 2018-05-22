#!/usr/bin/env bash
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

if [ "X${2:-}" != "X" ]; then
    byte=$2
else
    byte=c1
fi
{
    echo 8004000009028000002c800006$byte
    echo -n 8004810081
    echo "$1"
} | nix-shell ledger-blue-shell.nix --pure --run 'python -m ledgerblue.runScript --apdu'
