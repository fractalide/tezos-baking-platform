/*opam-version: "2.0"
  name: "base-unix"
  version: "base"
  maintainer: "https://github.com/ocaml/opam-repository/issues"
  depends: ["ocaml"]*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in

stdenv.mkDerivation rec {
  pname = "base-unix";
  version = "base";
  name = "${pname}-${version}";
  inherit doCheck;
  src = (import <nixpkgs> {}).runCommand "empty" { outputHashMode = "recursive"; outputHashAlgo = "sha256"; outputHash = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5"; } "mkdir $out";
  buildInputs = [
    ocaml findlib ];
  propagatedBuildInputs = [
    ocaml ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
