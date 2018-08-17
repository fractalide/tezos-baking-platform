/*opam-version: "2.0"
  name: "pprint"
  version: "20180528"
  synopsis: "A pretty-printing combinator library and rendering
  engine."
  description: """
  This library offers a set of combinators for building so-called "documents"
  as
  well as an efficient engine for converting documents to a textual,
  fixed-width
  format. The engine takes care of indentation and line breaks, while
  respecting
  the constraints imposed by the structure of the document and by the text
  width."""
  maintainer: "francois.pottier@inria.fr"
  authors: [
    "François Pottier <francois.pottier@inria.fr>"
    "Nicolas Pouillard <np@nicolaspouillard.fr>"
  ]
  homepage: "https://github.com/fpottier/pprint"
  bug-reports: "francois.pottier@inria.fr"
  depends: [
    "ocaml" {>= "4.02"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
  ]
  build: [make "all"]
  install: [make "install"]
  remove: [make "uninstall"]
  dev-repo: "git+ssh://git@github.com/fpottier/pprint.git"
  url {
    src: "https://github.com/fpottier/pprint/archive/20180528.tar.gz"
    checksum: "md5=a75651b51ba6668cd6121799986a1ca2"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02";

stdenv.mkDerivation rec {
  pname = "pprint";
  version = "20180528";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/fpottier/pprint/archive/20180528.tar.gz";
    sha256 = "0ad86yapx0ylgdkzb4z9wpbvfk5lzwgirib4b6gj2cj84gjxn906";
  };
  buildInputs = [
    ocaml findlib ocamlbuild ];
  propagatedBuildInputs = [
    ocaml ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'all'" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'install'" ] ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
