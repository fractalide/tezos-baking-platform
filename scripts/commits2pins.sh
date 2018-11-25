#!/usr/bin/env nix-shell
#! nix-shell --pure -p bash coreutils git nix-prefetch-git -i bash

set -euo pipefail

commit_pattern='^160000 (.{40}) '
for path_key in $(git config -l --name-only -f .gitmodules | grep -E '[.]path$'); do
  path=$(git config --get -f .gitmodules $path_key)
  if ! [[ $(git ls-files -s "$path") =~ $commit_pattern ]]; then continue; fi

  rev=${BASH_REMATCH[1]}
  section=${path_key%.path}
  url_key=$section.url
  url_impure_gitlab_github=$(git config -f .gitmodules --get $url_key)
  url_impure_github=${url_impure_gitlab_github/git@gitlab.com:/https://gitlab.com/}
  url=${url_impure_github/git@github.com:/https://github.com/}
  git submodule deinit -f "$path"
  git rm --cached "$path"
  git config -f .gitmodules --remove-section $section
  git add .gitmodules
  rm -rf "$path"
  mkdir "$path"
  nix-prefetch-git "$url" "$rev" > "$path/default.json"
  git cat-file blob 383f25014cab0c97d334506f0b586feb720c48ef > "$path/default.nix"
  git cat-file blob 9eafba8966d448a99fa19e551356510c879775cd > "$path/fetch.nix"
  git cat-file blob 55722f9a6d7064335e8ab597e245e7a3cffbef12 > "$path/bump.sh"
  git add "$path"
done
