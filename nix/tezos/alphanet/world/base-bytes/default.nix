/*opam-version: "2.0"
  name: "base-bytes"
  version: "base"
  synopsis: "Bytes library distributed with the OCaml compiler"
  maintainer: " "
  authors: " "
  homepage: " "
  depends: [
    "ocaml" {>= "4.02.0"}
    "ocamlfind" {>= "1.5.3"}
  ]*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.0") >= 0;
assert (vcompare findlib "1.5.3") >= 0;

stdenv.mkDerivation rec {
  pname = "base-bytes";
  version = "base";
  name = "${pname}-${version}";
  inherit doCheck;
  src = "/var/empty";
  buildInputs = [
    ocaml findlib ];
  propagatedBuildInputs = [
    ocaml findlib ];
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
