#!/bin/sh
set -eu

cd "$(dirname "$0")"

export app_hex="$1"
export app_name="$2"

#TODO: Pin nixpkgs
nix-shell ledger-blue-shell.nix --run 'set -x; ./install.sh "'"$app_hex"'" "'"$app_name"'"'
