#!/usr/bin/env nix-shell
#! nix-shell --quiet -p bash gawk git nix-prefetch-git -i bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

url_pattern='[^"]*"url": "([^"]*)"'
url=
while IFS='' read -r line; do
  [[ $line =~ $url_pattern ]] || continue
  url=${BASH_REMATCH[1]}
  break
done < default.json

rev=${1:-HEAD}

if (( ${#rev} != 40 )); then
  rev=$(git ls-remote $url "$rev" | awk '{ print $1 }')
fi

nix-prefetch-git $url $rev > default.json.new
mv default.json{.new,}
