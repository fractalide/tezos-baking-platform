let
  mkJobs = nixpkgs: let
    pkgs = import ./. { inherit nixpkgs; };
    inherit (nixpkgs) lib;
  in {
    # inherit (pkgs) bake-central-docker tezos-bake-central tezos-loadtest;
  } // lib.listToAttrs (map (name: lib.nameValuePair name pkgs.tezos.${name}.kit)
                            (builtins.attrNames (removeAttrs pkgs.tezos ["betanet"])));

in mkJobs (import ./nix/nixpkgs.nix {}) // {
}
