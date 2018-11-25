let
  mkJobs = nixpkgs: let
    pkgs = import ./. { inherit nixpkgs; };
    inherit (nixpkgs) lib;
  in {
    # inherit (pkgs) tezos-loadtest;
    inherit (pkgs) tezos-bake-central bake-central-docker;
  } // lib.listToAttrs (map (name: lib.nameValuePair name pkgs.tezos.${name}.kit)
                            (builtins.attrNames pkgs.tezos));

in mkJobs (import ./nix/nixpkgs.nix {}) // {
  latest-nixpkgs = mkJobs (import <nixpkgs> {});
}
