{ pkgs ? import ../nix/nixpkgs.nix {}
, bakingApp }:

pkgs.runCommand "ledger-app-built-${if bakingApp then "" else "no-"}baking" {
  src = ./.;
  ledgerApp = import ../nix/pins/ledger-app;
  BAKING_APP = if bakingApp then "y" else "";
  BOLOS_ENV = import ./bolos-env.nix {};
  BOLOS_SDK = import ../nix/pins/nanos-secure-sdk;
  fhs = import ./fhs.nix;
} ''
set -euo pipefail
cp -a $src $out
cd $out
chmod -R u+w .
rm -rf ledger-app  # In case the submodule is still hanging around
cp -a $ledgerApp ledger-app
chmod -R u+w ledger-app

$fhs/bin/enter-fhs <<EOF
set -eux
cd ledger-app
export BOLOS_SDK=$BOLOS_SDK
export BOLOS_ENV=$BOLOS_ENV
export BAKING_APP=$BAKING_APP
make clean
make
EOF
''
