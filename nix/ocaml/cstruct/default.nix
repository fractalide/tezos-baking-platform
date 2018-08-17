/*opam-version: "2.0"
  name: "cstruct"
  version: "3.2.1"
  synopsis: "Access C-like structures directly from OCaml"
  description: """
  Cstruct is a library and syntax extension to make it easier to access
  C-like
  structures directly from OCaml.  It supports both reading and writing to
  these
  structures, and they are accessed via the `Bigarray` module."""
  maintainer: "anil@recoil.org"
  authors: [
    "Anil Madhavapeddy"
    "Richard Mortier"
    "Thomas Gazagnaire"
    "Pierre Chambart"
    "David Kaloper"
    "Jeremy Yallop"
    "David Scott"
    "Mindy Preston"
    "Thomas Leonard"
  ]
  license: "ISC"
  tags: ["org:mirage" "org:ocamllabs"]
  homepage: "https://github.com/mirage/ocaml-cstruct"
  bug-reports: "https://github.com/mirage/ocaml-cstruct/issues"
  depends: [
    "ocaml" {>= "4.03.0"}
    "jbuilder" {build & >= "1.0+beta10"}
    "sexplib"
    "ounit" {with-test}
  ]
  build: [
    ["jbuilder" "subst" "-p" name "--name" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name] {with-test}
  ]
  dev-repo: "git+https://github.com/mirage/ocaml-cstruct.git"
  url {
    src:
     
  "https://github.com/mirage/ocaml-cstruct/releases/download/v3.2.1/cstruct-3.2.1.tbz"
    checksum: "md5=c1eb6a48f3d3b0b1e358f06a8c92a4c1"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, sexplib,
  ounit ? null, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.03.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta10";

stdenv.mkDerivation rec {
  pname = "cstruct";
  version = "3.2.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v3.2.1/cstruct-3.2.1.tbz";
    sha256 = "17nb40ajwl9aslhf7p8jgpp8bl270vmsqwak8rml956cs4gli7qa";
  };
  buildInputs = [
    ocaml jbuilder sexplib ]
  ++
  stdenv.lib.optional
  doCheck
  ounit
  ++
  [
    findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder sexplib ]
  ++
  stdenv.lib.optional
  doCheck
  ounit;
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] (stdenv.lib.optionals
    doCheck [ "'jbuilder'" "'runtest'" "'-p'" pname ]) ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
