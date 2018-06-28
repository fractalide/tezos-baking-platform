#!/usr/bin/env bash
set -eu

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$DIR"

export app_name="$1"

nix-shell ledger-blue-shell.nix --run 'set -x; ./ledger-app/install.sh "'"$app_name"'"'
