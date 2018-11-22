#!/usr/bin/env bash
set -eu

cd "$(dirname "${BASH_SOURCE[0]}")"

if ! [ "${1:-X}" = wallet ]; then
    app=$(nix-build build.nix --arg bakingApp true)
    $app/install-nix.sh 'Tezos Baking'${2:-}
fi
if ! [ "${1:-X}" = bake ]; then
    app=$(nix-build build.nix --arg bakingApp false)
    $app/install-nix.sh 'Tezos Wallet'${2:-}
fi
