#!/usr/bin/env bash
set -euo pipefail
#TODO: Fully nixify this build

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$DIR"

BOLOS_ENV=$(nix-build --no-out-link bolos-env.nix)
export BOLOS_ENV
export BOLOS_SDK="$PWD/nanos-secure-sdk"

"$(nix-build --no-out-link fhs.nix)/bin/enter-fhs" <<EOF
set -eux
cd ledger-app
export BOLOS_SDK=$BOLOS_SDK
export BOLOS_ENV=$BOLOS_ENV
export BAKING_APP=${BAKING_APP:-}
make clean
make
EOF
