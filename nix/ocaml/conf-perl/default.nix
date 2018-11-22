/*opam-version: "2.0"
  name: "conf-perl"
  version: "1"
  synopsis: "Virtual package relying on perl"
  description:
    "This package can only install if the perl program is installed on the
  system."
  maintainer: "tim@gfxmonk.net"
  license: "GPL-1+"
  homepage: "https://www.perl.org/"
  bug-reports: "https://github.com/ocaml/opam-repository/issues"
  depends: ["ocaml"]
  build: ["perl" "--version"]
  depexts: [
    ["perl"] {os-distribution = "debian"}
    ["perl"] {os-distribution = "ubuntu"}
    ["perl"] {os-distribution = "alpine"}
    ["perl"] {os-distribution = "nixos"}
    ["perl"] {os-distribution = "archlinux"}
    ["perl-Pod-Html"] {os-distribution = "fedora"}
  ]
  dev-repo: "git+https://github.com/ocaml/opam-repository.git"*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, perl }:

stdenv.mkDerivation rec {
  pname = "conf-perl";
  version = "1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = (import <nixpkgs> {}).runCommand "empty" { outputHashMode = "recursive"; outputHashAlgo = "sha256"; outputHash = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5"; } "mkdir $out";
  buildInputs = [
    ocaml findlib perl ];
  propagatedBuildInputs = [
    ocaml perl ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'perl'" "'--version'" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
