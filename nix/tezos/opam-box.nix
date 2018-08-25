{ stdenv, opam, ocaml, bubblewrap, curl, git, gmp, hidapi, libev, m4, rsync, perl, pkgconfig, unzip, which }:
stdenv.mkDerivation {
  name = "tezos-opam-sandbox-0";
  src = null;
  doUnpack = false;
  phases = [ "buildPhase" ];
  buildPhase = "mkdir -p $out";
  nativeBuildInputs = [
    opam
    ocaml
    bubblewrap
    curl
    git
    gmp
    hidapi
    libev
    m4
    rsync
    perl
    pkgconfig
    unzip
    which
  ];
}
