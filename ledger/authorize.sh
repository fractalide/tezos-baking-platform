#!/bin/sh
set -eu

DIR=$( cd "$( dirname "$0" )" && pwd )
cd "$DIR"

length="$(echo -n "$1" | wc -c)"

{
    printf "80010000%02x%02x%s\n" $(expr $length / 2 + 1) $(expr $length / 8) "$1"
} | nix-shell ledger-blue-shell.nix --pure --run 'python -m ledgerblue.runScript --apdu'
