{ pkgs ? import <nixos-next-stable> {} }:

rec {
    o = pkgs.ocamlPackages_latest;
    inherit (pkgs) lib;
    opam2nix = pkgs.callPackage ./opam2nix-packages.nix { inherit pkgs; };

    addBuildInputs = p: buildInputs: lib.overrideDerivation p (attrs: {
      buildInputs = (attrs.buildInputs or []) ++ buildInputs;
    });

    opamSolution = opam2nix.buildOpamPackages {
      packagesParsed = [
        {
          packageName = "irmin-leveldb";
          version = "0.0.0";
          src = vendors/irmin-leveldb;
        }
      ];
      userOverrides = { self, super }: {
        leveldb = addBuildInputs super.leveldb [pkgs.snappy];
      };
    };
    #tezos-node = opam2nix.buildOpamPackage rec {
    #  name = "tezos-node";
    #  version = "0.0.0";
    #  src = src/bin_node;
    #};
    #tezos-embedded-protocol-alpha = opam2nix.buildOpamPackage rec {
    #  name = "tezos-embedded-protocol-alpha";
    #  version = "0.0.0";
    #  src = src/proto_alpha/lib_protocol;
    #  opamFile = src/proto_alpha/lib_protocol/tezos-embedded-protocol-alpha.opam;
    #};
    #tezos-protocol-updater = opam2nix.buildOpamPackage rec {
    #  name = "tezos-protocol-updater";
    #  version = "0.0.0";
    #  src = src/lib_protocol_updater;
    #};
    #tezos-storage = opam2nix.buildOpamPackage rec {
    #  name = "tezos-storage";
    #  version = "0.0.0";
    #  src = src/lib_storage;
    #  extraPackages = ["irmin-leveldb"];
    #};
    final = pkgs.stdenv.mkDerivation {
      name = "tezos";
      src = ./.;
      buildInputs = with opamSolution.packageSet;
        [ocaml
         findlib
         irmin-leveldb
        ];
    };
}
