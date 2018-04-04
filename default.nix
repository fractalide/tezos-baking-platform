{ pkgs ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/b6ddb9913f2.tar.gz";
    sha256 = "1yjbd5jhjgirv7ki0sms1x13dqyjzg0rpb7n67m6ik61fmpq0nfw";
  }) {}
}:

rec {
  o = pkgs.ocamlPackages_latest;
  inherit pkgs;
  inherit (pkgs) lib;
  opam2nix = pkgs.callPackage ./opam2nix-packages.nix { inherit pkgs; };
  addBuildInputs = p: buildInputs: lib.overrideDerivation p (attrs: {
    buildInputs = (attrs.buildInputs or []) ++ buildInputs;
  });
  fauxpam = pkgs.writeScript "opam" "echo";
  onOpamSelection = f: { self, super }:
    { 
      opamSelection = super.opamSelection //
        f { self = self.opamSelection; super = super.opamSelection; };
    }; 

  opamSolution = opam2nix.buildOpamPackages {
    ocamlAttr = "ocamlPackages_latest.ocaml";
    specs = [
      { name = "jbuilder"; constraint = "=1.0+beta19"; }
      { name = "ocb-stubblr"; }
    ];
    packagesParsed = [
      {
        packageName = "ocplib-resto-cohttp";
        version = "0.0.0";
        src = vendors/ocplib-resto/lib_resto-cohttp;
      }
      {
        packageName = "ocplib-resto-directory";
        version = "dev";
        src = vendors/ocplib-resto/lib_resto-directory;
      }
      {
        packageName = "tweetnacl";
        version = "dev";
        src = vendors/ocaml-tweetnacl;
      }
      {
        packageName = "blake2";
        version = "dev";
        src = vendors/ocaml-blake2;
      }
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
        packageName = "tezos-crypto";
        version = "0.0.0";
        src = src/lib_crypto;
      }
      {
        packageName = "tezos-stdlib";
        version = "0.0.0";
        src = src/lib_stdlib;
      }
      {
        packageName = "tezos-shell";
        version = "0.0.0";
        src = src/lib_shell;
      }
      {
        packageName = "tezos-shell-services";
        version = "0.0.0";
        src = src/lib_shell_services;
      }
      {
        packageName = "tezos-micheline";
        version = "0.0.0";
        src = src/lib_micheline;
      }
      {
        packageName = "tezos-error-monad";
        version = "0.0.0";
        src = src/lib_error_monad;
      }
      {
        packageName = "tezos-data-encoding";
        version = "0.0.0";
        src = src/lib_data_encoding;
      }
      {
        packageName = "tezos-rpc";
        version = "0.0.0";
        src = src/lib_rpc;
      }
      {
        packageName = "tezos-rpc-http";
        version = "0.0.0";
        src = src/lib_rpc_http;
      }
      {
        packageName = "tezos-p2p";
        version = "0.0.0";
        src = src/lib_p2p;
      }
      {
        packageName = "tezos-protocol-environment";
        version = "0.0.0";
        src = src/lib_protocol_environment;
        opamFile = src/lib_protocol_environment/tezos-protocol-environment.opam;
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
      {
        packageName = "tezos-protocol-environment-sigs";
        version = "0.0.0";
        src = src/lib_protocol_environment;
        opamFile = src/lib_protocol_environment/tezos-protocol-environment-sigs.opam;
      }
    ];
    overrides = onOpamSelection ({ self, super }: {
      leveldb = addBuildInputs super.leveldb [pkgs.snappy];
      ocplib-resto-directory = addBuildInputs super.ocplib-resto-directory [super.jbuilder super.lwt];
      cpuid = addBuildInputs super.cpuid [ fauxpam ];
      ocaml-migrate-parsetree = addBuildInputs super.ocaml-migrate-parsetree [super.result];
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
