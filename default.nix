{ pkgs ? import <nixos-next-stable> {} }:

rec {
    o = pkgs.ocamlPackages_latest;
    lib = pkgs.lib;
    opam2nix = pkgs.callPackage ./opam2nix-packages.nix { inherit pkgs; };
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
    addInputs = p: inps: lib.overrideDerivation p (attrs: {
      buildInputs = attrs.buildInputs ++ inps;
    });
    leveldb = addInputs irmin-leveldb.opamSelection.leveldb [pkgs.snappy]; 
    irmin-leveldb = opam2nix.buildOpamPackage {
      name = "irmin-leveldb";
      version = "0.0.0";
      src = vendors/irmin-leveldb;
      extraPackages = [leveldb];
    };
    final = pkgs.stdenv.mkDerivation {
      name = "tezos";
      src = ./.;
      buildInputs = with o;
        [ocaml
         findlib
         irmin-leveldb
        ];
    };
}
