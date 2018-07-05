#!/bin/sh
set -eu
exec nix-shell -A sandbox --argstr time_between_blocks '["3","3"]' --argstr max_peer_id 9 "$@"
