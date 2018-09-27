{ nixpkgs ? import nix/nixpkgs.nix {}
}:
nixpkgs.lib.makeScope nixpkgs.newScope (self:
let
  inherit (self) callPackage;
  pkgs = nixpkgs;
  inherit (nixpkgs) lib fetchgit haskell dockerTools runCommand;
  tezos-bake-monitor-src = import ./nix/pins/tezos-bake-monitor;
in
rec {
  pkgs = self;

  combineOverrides = old: new: (old // new) // {
    overrides = lib.composeExtensions old.overrides new.overrides;
  };
  makeRecursivelyOverridable = x: old: x.override old // {
    override = new: makeRecursivelyOverridable x (combineOverrides old new);
  };

  haskellPackages = makeRecursivelyOverridable haskell.packages.ghc822 { overrides = self: super: {
    "ListLike" = haskell.lib.addBuildDepends super.ListLike [ self.semigroups ];
  }; };

  fetchThunk = p: if builtins.pathExists (p + /git.json)
    then fetchgit { inherit (builtins.fromJSON (builtins.readFile (p + /git.json))) url rev sha256; }
    else p;

  fauxpam = callPackage nix/fauxpam.nix {};

  tezos = {
    master = callPackage nix/tezos { tezos-src = fetchThunk tezos/master; tezos-world-path = nix/tezos/master/world; };
    zeronet = callPackage nix/tezos { tezos-src = fetchThunk tezos/zeronet; tezos-world-path = nix/tezos/zeronet/world; };
    alphanet = callPackage nix/tezos { tezos-src = fetchThunk tezos/alphanet; tezos-world-path = nix/tezos/alphanet/world; };
    betanet = callPackage nix/tezos { tezos-src = fetchThunk tezos/betanet; tezos-world-path = nix/tezos/betanet/world; };
    mainnet = callPackage nix/tezos { tezos-src = fetchThunk tezos/mainnet; tezos-world-path = nix/tezos/mainnet/world; };
  };

  tezos-bake-monitor = callPackage tezos-bake-monitor-src { };

  tezos-loadtest = (import "${tezos-bake-monitor-src}/tezos-bake-central/.obelisk/impl" {}).reflex-platform.nixpkgs.haskellPackages.callCabal2nix "tezos-load-testing" ./tezos-load-testing {};

  tezos-bake-central = (nixpkgs.callPackage "${tezos-bake-monitor-src}/tezos-bake-central/release.nix" {}).releaseExe;

  bake-central-docker = let
    bakeCentralSetupScript = dockerTools.shellScript "dockersetup.sh" ''
      set -ex

      ${dockerTools.shadowSetup}
      echo 'nobody:x:99:99:Nobody:/:/sbin/nologin' >> /etc/passwd
      echo 'nobody:*:17416:0:99999:7:::'           >> /etc/shadow
      echo 'nobody:x:99:'                          >> /etc/group
      echo 'nobody:::'                             >> /etc/gshadow

      mkdir -p    /var/run/bake-monitor
      chown 99:99 /var/run/bake-monitor
    '';
    bakeCentralEntrypoint = dockerTools.shellScript "entrypoint.sh" ''
      set -ex

      mkdir -p /var/run/bake-monitor
      ln -sft /var/run/bake-monitor '${tezos-bake-central}'/*
      rm /var/run/bake-monitor/config
      mkdir -p /var/run/bake-monitor/config

      cd /var/run/bake-monitor
      exec ./backend "$@"
    '';
  in dockerTools.buildImage {
    name = "tezos-bake-monitor";
    contents = [ nixpkgs.iana-etc nixpkgs.cacert ];
    runAsRoot = bakeCentralSetupScript;
    keepContentsDirlinks = true;
    config = {
     Env = [
        ("PATH=" + builtins.concatStringsSep(":")([
          "${nixpkgs.stdenv.shellPackage}/bin"
          "${nixpkgs.coreutils}/bin"
        ]))
      ];
      Expose = 8000;
      Entrypoint = [bakeCentralEntrypoint];
      User = "99:99";
    };
  };
})
