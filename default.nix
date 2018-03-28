{ pkgs ? (import ./nixpkgs {}) }:
let o = pkgs.ocamlPackages_latest;
    opam2nix = pkgs.callPackage ./opam2nix-packages.nix { inherit pkgs; };
    tezos-node = opam2nix.buildOpamPackage rec {
      name = "tezos-node";
      src = src/bin_node;
    };
in pkgs.stdenv.mkDerivation {
  name = "tezos";
  src = ./.;
  buildInputs = with o;
    [ocaml
     findlib
     tezos-node];
}
