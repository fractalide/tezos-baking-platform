#!/usr/bin/env bash
set -euo pipefail

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$DIR"

{
    echo 8001000209028000002c800006c1
} | nix-shell ledger-blue-shell.nix --pure --run 'python -m ledgerblue.runScript --apdu'
