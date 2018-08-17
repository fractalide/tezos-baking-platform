/*opam-version: "2.0"
  name: "astring"
  version: "0.8.3"
  synopsis: "Alternative String module for OCaml"
  description: """
  Astring exposes an alternative `String` module for OCaml. This module
  tries to balance minimality and expressiveness for basic, index-free,
  string processing and provides types and functions for substrings,
  string sets and string maps.
  
  Remaining compatible with the OCaml `String` module is a non-goal.
  The
  `String` module exposed by Astring has exception safe functions,
  removes deprecated and rarely used functions, alters some signatures
  and names, adds a few missing functions and fully exploits OCaml's
  newfound string immutability.
  
  Astring depends only on the OCaml standard library. It is distributed
  under the ISC license."""
  maintainer: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  authors: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  license: "ISC"
  tags: ["string" "org:erratique"]
  homepage: "http://erratique.ch/software/astring"
  doc: "http://erratique.ch/software/astring/doc"
  bug-reports: "https://github.com/dbuenzli/astring/issues"
  depends: [
    "ocaml" {>= "4.01.0"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build}
    "base-bytes"
  ]
  build: ["ocaml" "pkg/pkg.ml" "build" "--pinned" "%{pinned}%"]
  dev-repo: "git+http://erratique.ch/repos/astring.git"
  url {
    src: "http://erratique.ch/software/astring/releases/astring-0.8.3.tbz"
    checksum: "md5=c5bf6352b9ac27fbeab342740f4fa870"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  base-bytes }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01.0";

stdenv.mkDerivation rec {
  pname = "astring";
  version = "0.8.3";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://erratique.ch/software/astring/releases/astring-0.8.3.tbz";
    sha256 = "0ixjwc3plrljvj24za3l9gy0w30lsbggp8yh02lwrzw61ls4cri0";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg base-bytes ];
  propagatedBuildInputs = [
    ocaml base-bytes ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
