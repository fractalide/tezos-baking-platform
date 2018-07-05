#!/bin/sh
set -eu
echo "This script is designed to be run inside the 'sandbox' nix shell"
tezos-node identity generate || :
tezos-node config init || :
peers="$(curl -s 'http://zeronet-api.tzscan.io/v1/network?state=running&p=0&number=50' | grep -Po '::ffff:([0-9.:]+)' | sort -u | sed ':a;N;$!ba;s/\n/ /g' | sed 's/::ffff:/--peer=/g')" # From https://gist.github.com/dakk/bdf6efe42ae920acc660b20080a506dd
set -x
exec tezos-node run --rpc-addr :8732 --connections 10 $peers
