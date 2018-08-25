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
    ["jbuilder" "subst" "-p" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git+https://github.com/ocaml/ocaml-re.git"
  url {
    src:
     
  "https://github.com/ocaml/ocaml-re/releases/download/1.7.3/re-1.7.3.tbz"
    checksum: [
      "md5=d2a74ca77216861bce4449600a132de9"
     
  "sha256=d9674725760f926c6f4687bc8d449d6db8f839551a6ecc5288c923eaf018695b"
     
  "sha512=bfc50d7bf98116353bd50a1e5edabe3b4066f984bd3fa59aaf3a0461b7f8d6a171f0461925c6b711c190b4589433a2a34f9156132c11e8b5fffb0b79e53e435a"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, ounit ? null,
  findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.3") >= 0;
assert (vcompare jbuilder "1.0+beta10") >= 0;

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
