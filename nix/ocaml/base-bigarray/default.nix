/*opam-version: "2.0"
  name: "base-bigarray"
  version: "base"
  synopsis: "Bigarray library distributed with the OCaml compiler"
  maintainer: "https://github.com/ocaml/opam-repository/issues"
  depends: ["ocaml"]*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:

stdenv.mkDerivation rec {
  pname = "base-bigarray";
  version = "base";
  name = "${pname}-${version}";
  inherit doCheck;
  src = (import <nixpkgs> {}).runCommand "empty" {} "mkdir $out";
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
