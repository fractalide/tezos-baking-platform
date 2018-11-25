{ nixpkgs ? import nix/nixpkgs.nix {}
}:
nixpkgs.lib.makeScope nixpkgs.newScope (self:
let
  inherit (self) callPackage;
  pkgs = nixpkgs;
  inherit (nixpkgs) lib fetchgit haskell;
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

  inherit (import ./tezos-bake-monitor {}) obelisk;
  obeliskNixpkgs = obelisk.reflex-platform.nixpkgs;
  tezos-loadtest = obeliskNixpkgs.haskellPackages.callCabal2nix "tezos-loadtest" ./tezos-load-testing {};

  tezos-bake-central = (import ./tezos-bake-monitor {}).exe;
  bake-central-docker = (import ./tezos-bake-monitor {}).dockerImage;
})
