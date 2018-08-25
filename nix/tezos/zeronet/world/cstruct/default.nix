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
    checksum: [
      "md5=c1eb6a48f3d3b0b1e358f06a8c92a4c1"
     
  "sha256=0a9f481fd1cc94446b465371aceb0647d085ee7d12dde320d52a512e1520cb9e"
     
  "sha512=1913eb1756ddbf1ee74de1830be2a073b78c1dd447ae0f011cc0ce54c0d9cf36cd3b1e05bb7157c05d168f6920e590a5e99a9308493ac475c01d9a5609a50806"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, sexplib,
  ounit ? null, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.03.0") >= 0;
assert (vcompare jbuilder "1.0+beta10") >= 0;

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
