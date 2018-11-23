#!/usr/bin/env bash

set -euo pipefail

cd "${BASH_SOURCE[0]%/*}"

nixpkgs=$(nix-instantiate --eval -E 'with import <nixpkgs> {}; path')
sandbox=$(nix-instantiate --eval -E 'with import <nixpkgs> {}; if stdenv.isDarwin then "" else "--option sandbox true"')
exec nix-build --option restrict-eval true ${sandbox//\"/} -I pwd=$PWD -I nixpkgs=$nixpkgs release.nix "$@"
