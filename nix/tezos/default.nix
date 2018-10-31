{ lib, newScope, ocaml-ng, opam, stdenv, tezos-src, tezos-world-path }:
lib.makeScope newScope (self:
let
  inherit (self) callPackage;
in
{
  pkgs = self;
  inherit lib;
  inherit ocaml-ng;
  inherit tezos-src;
  inherit tezos-world-path;

  world = callPackage tezos-world-path {};

  kit = self.world.callPackage ./kit.nix { inherit tezos-src; };

  opam-box = self.world.callPackage ./opam-box.nix {};

  sandbox = callPackage ./sandbox.nix {};

  # keep this open for sandbox to provide parameters to
  sandbox-env = callPackage ./sandbox-env.nix;
  stdenv = stdenv // {
    mkDerivation = { ... }@args: stdenv.mkDerivation ({
      postPatch = "patchShebangs .";
    } // args);
  };
})
