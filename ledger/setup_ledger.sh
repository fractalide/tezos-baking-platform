#!/usr/bin/env bash
set -eu

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$DIR"

BAKING_APP='' ./build.sh
./install-nix.sh 'Tezos Wallet'
BAKING_APP=Y ./build.sh
./install-nix.sh 'Tezos Bake'
