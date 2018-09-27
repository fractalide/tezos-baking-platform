#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash gawk git nix-prefetch-git

set -e
set -u
set -o pipefail

baseurl=https://github.com
repo=LedgerHQ/nanos-secure-sdk
branch=refs/heads/master

SCRIPT_NAME=${BASH_SOURCE[0]##*/}

cd "${BASH_SOURCE[0]%$SCRIPT_NAME}"

if (( $# > 1 )); then
  echo "Usage: $SCRIPT_NAME [revision]"
  exit 2
fi

if (( $# == 1 )); then
  rev=$1
else
  rev=$(git ls-remote $baseurl/$repo.git |
          awk '$2 == "'"$branch"'" { print $1 }')
fi

nix-prefetch-git --no-deepClone $baseurl/$repo.git $rev > default.json.new
mv default.json{.new,}
