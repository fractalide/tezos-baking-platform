let
  mkJobs = nixpkgs: let
    pkgs = import ./. { inherit nixpkgs; };
    inherit (nixpkgs) lib;
  in {
    # inherit (pkgs) bake-central-docker tezos-bake-central tezos-loadtest;
    ledger-baker = pkgs.callPackage ledger/build.nix { bakingApp = true; };
    ledger-wallet = pkgs.callPackage ledger/build.nix { bakingApp = false; };
  } // lib.listToAttrs (map (name: lib.nameValuePair name pkgs.tezos.${name}.kit)
                            (builtins.attrNames (removeAttrs pkgs.tezos ["betanet"])));

in mkJobs (import ./nix/nixpkgs.nix {}) // {
  latest-nixpkgs = mkJobs (import <nixpkgs> {});
}
