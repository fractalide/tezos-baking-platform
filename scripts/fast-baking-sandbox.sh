#!/usr/bin/env bash
set -eux
cd "$(dirname "$0")"/..
exec nix-shell -A tezos.master.sandbox --argstr time_between_blocks '["3","3"]' --argstr max_peer_id 9 "$@"
