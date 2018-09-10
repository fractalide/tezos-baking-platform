{ lib, newScope, ocaml-ng, opam, tezos-src, tezos-world-path }:
lib.makeScope newScope (self:
let
  inherit (self) callPackage;
in
rec {
  pkgs = self;
  inherit lib;
  inherit ocaml-ng;
  inherit tezos-src;
  inherit tezos-world-path;

  world = callPackage tezos-world-path {};

  kit = world.callPackage ./kit.nix { inherit tezos-src; };

  opam-box = world.callPackage ./opam-box.nix {};

  sandbox = callPackage ./sandbox.nix {};

  # keep this open for sandbox to provide parameters to
  sandbox-env = callPackage ./sandbox-env.nix;
})
