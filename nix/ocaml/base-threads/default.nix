/*opam-version: "2.0"
  name: "base-threads"
  version: "base"
  synopsis: "Threads library distributed with the OCaml compiler"
  maintainer: "https://github.com/ocaml/opam-repository/issues"
  depends: ["ocaml"]*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:

stdenv.mkDerivation rec {
  pname = "base-threads";
  version = "base";
  name = "${pname}-${version}";
  inherit doCheck;
  src = "/var/empty";
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
