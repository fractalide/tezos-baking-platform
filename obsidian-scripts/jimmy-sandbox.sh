#!/bin/sh
set -eu
exec nix-shell -A sandbox --argstr time_between_blocks '[1,1]' --argstr max_peer_id 2 "$@"
