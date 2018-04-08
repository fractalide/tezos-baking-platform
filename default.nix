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

  fauxpam = pkgs.runCommand "fauxpam" {} ''
    mkdir -p "$out/bin"
    cat >"$out/bin/opam" <<'EOF'
    #!/bin/sh
    echo "$@"
    EOF
    chmod +x "$out/bin/opam"
  ''; # (extremely) fake opam executable that packages can use when requesting certain opam configs that may be blank

  onOpamSelection = f: { self, super }:
    { 
      opamSelection = super.opamSelection //
        f { self = self.opamSelection; super = super.opamSelection; };
    }; 

  opamSolution = opam2nix.buildOpamPackages {
    ocamlAttr = "ocamlPackages_latest.ocaml";
    specs = [
      { name = "jbuilder"; constraint = "=1.0+beta19.1"; }
      { name = "ocb-stubblr"; }
      { name = "cpuid"; }
    ];
    packagesParsed = [
      {
        packageName = "bip39";
        version = "dev";
        src = vendors/ocaml-bip39;
      }
      {
        packageName = "ocplib-json-typed";
        version = "dev";
        src = pkgs.fetchgit {
          url = "https://github.com/OCamlPro/ocplib-json-typed";
          rev = "28bb9ec633049eb5a5461ead2d85685a47be81c5";
          sha256 = "19czgk5pi62kz0gzz73h3p3iq0scz602lk6qhwn1v38sfssh1qwy";
        };
      }
      {
        packageName = "ocplib-resto";
        version = "dev";
        src = vendors/ocplib-resto/lib_resto;
      }
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
        packageName = "tezos-client";
        version = "0.0.0";
        src = src/bin_client;
      }
      {
        packageName = "tezos-client-base";
        version = "0.0.0";
        src = src/lib_client_base;
      }
      {
        packageName = "tezos-client-base-unix";
        version = "0.0.0";
        src = src/lib_client_base_unix;
      }
      {
        packageName = "tezos-protocol-alpha";
        version = "0.0.0";
        src = src/proto_alpha/lib_protocol;
        opamFile = src/proto_alpha/lib_protocol/tezos-protocol-alpha.opam;
      }
      {
        packageName = "tezos-baking-alpha-commands";
        version = "0.0.0";
        src = src/proto_alpha/lib_baking;
        opamFile = src/proto_alpha/lib_baking/tezos-baking-alpha-commands.opam;
      }
      {
        packageName = "tezos-baking-alpha";
        version = "0.0.0";
        src = src/proto_alpha/lib_baking;
        opamFile = src/proto_alpha/lib_baking/tezos-baking-alpha.opam;
      }
      {
        packageName = "tezos-client-alpha";
        version = "0.0.0";
        src = src/proto_alpha/lib_client;
      }
      {
        packageName = "tezos-client-alpha-commands";
        version = "0.0.0";
        src = src/proto_alpha/lib_client_commands;
      }
      {
        packageName = "tezos-client-commands";
        version = "0.0.0";
        src = src/lib_client_commands;
      }
      {
        packageName = "tezos-client-genesis";
        version = "0.0.0";
        src = src/proto_genesis/lib_client;
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
      leveldb = addBuildInputs super.leveldb [ pkgs.snappy ];
      ocplib-resto-cohttp = addBuildInputs super.ocplib-resto-cohttp [super.jbuilder super.lwt super.ocplib-resto self.ocplib-resto-directory];
      ocplib-resto-directory = addBuildInputs super.ocplib-resto-directory [super.jbuilder super.lwt super.ocplib-resto];
      tezos-rpc-http = addBuildInputs super.tezos-rpc-http [self.ocplib-resto-cohttp];
      cpuid = addBuildInputs super.cpuid [ fauxpam ];
      nocrypto = addBuildInputs super.nocrypto [ fauxpam ];
      tezos-node = addBuildInputs super.tezos-node [ pkgs.snappy ];
    });
  };
  node = opamSolution.packageSet.tezos-node;
  client = opamSolution.packageSet.tezos-client;
  final = pkgs.stdenv.mkDerivation {
    name = "tezos";
    src = ./.;
    buildInputs = (with opamSolution.packageSet; [
      tezos-node
    ]) ++ (with pkgs; [
      snappy
      opam
      stdenv
      m4
      gmp
      leveldb
      pkgconfig
      openssl
      omake
    ]);
  };
}
