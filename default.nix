{ pkgs ? import <nixos-next-stable> {} }:

rec {
  o = pkgs.ocamlPackages_latest;
  inherit pkgs;
  inherit (pkgs) lib;
  opam2nix = pkgs.callPackage ./opam2nix-packages.nix { inherit pkgs; };
  
  addBuildInputs = p: buildInputs: lib.overrideDerivation p (attrs: {
    buildInputs = (attrs.buildInputs or []) ++ buildInputs;
  });
  
  onOpamSelection = f: { self, super }:
    { 
      opamSelection = super.opamSelection //
        f { self = self.opamSelection; super = super.opamSelection; };
    }; 

  opamSolution = opam2nix.buildOpamPackages {
    ocamlAttr = "ocamlPackages_latest.ocaml";
    specs = [{ name = "jbuilder"; constraint = "=1.0+beta19"; } ];
    packagesParsed = [
      {
        packageName = "irmin-leveldb";
        version = "0.0.0";
        src = vendors/irmin-leveldb;
      }
      {
        packageName = "tezos-node";
        version = "0.0.0";
        src = src/bin_node;
      }
      {
        packageName = "tezos-embedded-protocol-alpha";
        version = "0.0.0";
        src = src/proto_alpha/lib_protocol;
        opamFile = src/proto_alpha/lib_protocol/tezos-embedded-protocol-alpha.opam;
      }
      {
        packageName = "tezos-protocol-compiler";
        version = "0.0.0";
        src = src/lib_protocol_compiler;
      }
      {
        packageName = "tezos-protocol-updater";
        version = "0.0.0";
        src = src/lib_protocol_updater;
      }
      {
        packageName = "tezos-storage";
        version = "0.0.0";
        src = src/lib_storage;
      }
      {
        packageName = "tezos-stdlib-unix";
        version = "0.0.0";
        src = src/lib_stdlib_unix;
      }
      {
        packageName = "tezos-embedded-protocol-demo";
        version = "0.0.0";
        src = src/proto_demo/lib_protocol;
        opamFile = src/proto_demo/lib_protocol/tezos-embedded-protocol-demo.opam;
      }
      {
        packageName = "tezos-base";
        version = "0.0.0";
        src = src/lib_base;
      }
      {
        packageName = "tezos-shell";
        version = "0.0.0";
        src = src/lib_shell;
      }
      {
        packageName = "tezos-p2p";
        version = "0.0.0";
        src = src/lib_p2p;
      }
      {
        packageName = "tezos-protocol-environment-shell";
        version = "0.0.0";
        src = src/lib_protocol_environment;
        opamFile = src/lib_protocol_environment/tezos-protocol-environment-shell.opam;
      }
      {
        packageName = "tezos-protocol-genesis";
        version = "0.0.0";
        src = src/proto_genesis/lib_protocol;
        opamFile = src/proto_genesis/lib_protocol/tezos-protocol-genesis.opam;
      }
      {
        packageName = "tezos-embedded-protocol-genesis";
        version = "0.0.0";
        src = src/proto_genesis/lib_protocol;
        opamFile = src/proto_genesis/lib_protocol/tezos-embedded-protocol-genesis.opam;
      }
    ];
    overrides = onOpamSelection ({ self, super }: {
      leveldb = addBuildInputs super.opamSelection.leveldb [pkgs.snappy];
    });
  };
  final = pkgs.stdenv.mkDerivation {
    name = "tezos";
    src = ./.;
    buildInputs = with opamSolution.packageSet; [
      ocaml
      o.findlib
      tezos-node
    ];
  };
}
