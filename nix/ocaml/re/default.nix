/*opam-version: "2.0"
  name: "re"
  version: "1.7.3"
  synopsis: "RE is a regular expression library for OCaml"
  description: """
  Pure OCaml regular expressions with:
  * Perl-style regular expressions (module Re.Perl)
  * Posix extended regular expressions (module Re.Posix)
  * Emacs-style regular expressions (module Re.Emacs)
  * Shell-style file globbing (module Re.Glob)
  * Compatibility layer for OCaml's built-in Str module (module
  Re.Str)"""
  maintainer: "rudi.grinberg@gmail.com"
  authors: [
    "Jerome Vouillon"
    "Thomas Gazagnaire"
    "Anil Madhavapeddy"
    "Rudi Grinberg"
    "Gabriel Radanne"
  ]
  license: "LGPL-2.0 with OCaml linking exception"
  homepage: "https://github.com/ocaml/ocaml-re"
  bug-reports: "https://github.com/ocaml/ocaml-re/issues"
  depends: [
    "ocaml" {>= "4.02.3"}
    "jbuilder" {build & >= "1.0+beta10"}
    "ounit" {with-test}
  ]
  build: [
    ["jbuilder" "subst" "-n" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git+https://github.com/ocaml/ocaml-re.git"
  url {
    src:
     
  "https://github.com/ocaml/ocaml-re/releases/download/1.7.3/re-1.7.3.tbz"
    checksum: "md5=d2a74ca77216861bce4449600a132de9"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, ounit ? null,
  findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.3";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta10";

stdenv.mkDerivation rec {
  pname = "re";
  version = "1.7.3";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml/ocaml-re/releases/download/1.7.3/re-1.7.3.tbz";
    sha256 = "0nv933qfl8y9i19cqvhsalwzif3dkm28vg478rpnr4hgfqjlfryr";
  };
  buildInputs = [
    ocaml jbuilder ]
  ++
  stdenv.lib.optional
  doCheck
  ounit
  ++
  [
    findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder ]
  ++
  stdenv.lib.optional
  doCheck
  ounit;
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] (stdenv.lib.optionals
    doCheck [ "'jbuilder'" "'runtest'" "'-p'" pname "'-j'" "1" ]) ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
