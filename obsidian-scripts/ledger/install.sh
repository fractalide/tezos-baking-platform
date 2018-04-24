#!/usr/bin/env bash
set -euo pipefail
#TODO: Fully nixify this build

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$DIR"

#TODO: Pin nixpkgs
nix-shell ledger-blue-shell.nix --pure --run 'python -m ledgerblue.loadApp --appFlags 0x00 --tlv --targetId 0x31100003 --delete --fileName blue-app-ssh-agent/bin/app.hex --appName "Tezos" --appVersion 1.0.0 $(ICONHEX=$(python nanos-secure-sdk/icon.py blue-app-ssh-agent/icon.gif hexbitmaponly 2>/dev/null) ; [ ! -z "$ICONHEX" ] && echo "--icon $ICONHEX")'
