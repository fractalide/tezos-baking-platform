#!/bin/sh
set -eu

cd "$(dirname "$0")"

export app_name="$1"

#TODO: Pin nixpkgs
nix-shell ledger-blue-shell.nix --run 'set -x; ./ledger-app/install.sh "'"$app_name"'"'
