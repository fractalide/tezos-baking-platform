{ pkgs ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/b6ddb9913f2.tar.gz";
    sha256 = "1yjbd5jhjgirv7ki0sms1x13dqyjzg0rpb7n67m6ik61fmpq0nfw";
  }) {}
}: let
  parentpkg = (pkgs.callPackage ../default.nix {});
  in pkgs.stdenv.mkDerivation {
    name = "tezos-sandbox-sandbox";
    src = ./.;
    phases = [ "unpackPhase" "buildPhase" ];
    nativeBuildInputs = [
      parentpkg.node
      parentpkg.client
      parentpkg.baker-alpha
      parentpkg.tezos-bake-monitor
      (parentpkg.sandbox {})
    ];
  }
