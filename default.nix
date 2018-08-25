{ pkgs ? import nix/nixpkgs.nix {}
}:
pkgs.lib.makeScope pkgs.newScope (self:
let
  inherit (self) callPackage;
  inherit pkgs;
  inherit (pkgs) lib fetchgit;
in
rec {
  pkgs = self;

  fetchThunk = p: if builtins.pathExists (p + /git.json)
    then fetchgit { inherit (builtins.fromJSON (builtins.readFile (p + /git.json))) url rev sha256; }
    else p;

  fauxpam = callPackage nix/fauxpam.nix {};

  tezos = {
    master = callPackage nix/tezos { tezos-src = fetchThunk tezos/master; tezos-world-path = nix/tezos/master/world; };
    zeronet = callPackage nix/tezos { tezos-src = fetchThunk tezos/zeronet; tezos-world-path = nix/tezos/zeronet/world; };
    alphanet = callPackage nix/tezos { tezos-src = fetchThunk tezos/alphanet; tezos-world-path = nix/tezos/alphanet/world; };
    betanet = callPackage nix/tezos { tezos-src = fetchThunk tezos/betanet; tezos-world-path = nix/tezos/betanet/world; };
  };

  tezos-bake-monitor = callPackage ./tezos-bake-monitor/tezos-bake-monitor {
    inherit pkgs;
  };

  tezos-loadtest = callPackage ./tezos-load-testing {
    inherit pkgs;
  };

  tezos-bake-central = (import ./tezos-bake-monitor/tezos-bake-central {}).exe;

  bake-central-docker = let
    bakeCentralSetupScript = pkgs.dockerTools.shellScript "dockersetup.sh" ''
      set -ex

      ${pkgs.dockerTools.shadowSetup}
      echo 'nobody:x:99:99:Nobody:/:/sbin/nologin' >> /etc/passwd
      echo 'nobody:*:17416:0:99999:7:::'           >> /etc/shadow
      echo 'nobody:x:99:'                          >> /etc/group
      echo 'nobody:::'                             >> /etc/gshadow

      mkdir -p    /var/run/bake-monitor
      chown 99:99 /var/run/bake-monitor
    '';
    bakeCentralEntrypoint = pkgs.dockerTools.shellScript "entrypoint.sh" ''
      set -ex

      mkdir -p /var/run/bake-monitor
      ln -sft /var/run/bake-monitor '${tezos-bake-central}'/*
      rm /var/run/bake-monitor/config
      mkdir -p /var/run/bake-monitor/config

      cd /var/run/bake-monitor
      exec ./backend "$@"
    '';
  in pkgs.dockerTools.buildImage {
    name = "tezos-bake-monitor";
    runAsRoot = bakeCentralSetupScript;
    keepContentsDirlinks = true;
    config = {
      Expose = 8000;
      Entrypoint = [bakeCentralEntrypoint];
      User = "99:99";
    };
  };
})
