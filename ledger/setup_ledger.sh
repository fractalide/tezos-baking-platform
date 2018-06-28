#!/bin/sh
set -eu
cd "$(dirname "$0")"

BAKING_APP= ./build.sh
./install-nix.sh "Tezos Wallet"
BAKING_APP=Y ./build.sh
./install-nix.sh "Tezos Bake"
