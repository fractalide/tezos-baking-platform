#!/usr/bin/env bash
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

{
    echo 8004000009${3:-02}8000002c800006c1${2:-}
    printf "80048100%02x" "$(expr $(echo -n "$1" | wc -c) / 2)"
    echo "$1"
} | nix-shell ledger-blue-shell.nix --pure --run 'python -m ledgerblue.runScript --apdu'
