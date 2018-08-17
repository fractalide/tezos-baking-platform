/*opam-version: "2.0"
  name: "stringext"
  version: "1.5.0"
  synopsis: "Extra string functions for OCaml"
  description: """
  Extra string functions for OCaml. Mainly splitting. All functions are in
  the
  `Stringext` module."""
  maintainer: "rudi.grinberg@gmail.com"
  authors: "Rudi Grinberg"
  license: "MIT"
  homepage: "https://github.com/rgrinberg/stringext"
  bug-reports: "https://github.com/rgrinberg/stringext/issues"
  depends: [
    "ocaml" {>= "4.02.3"}
    "jbuilder" {build & >= "1.0+beta10"}
    "ounit" {with-test}
    "qtest" {with-test & >= "2.2"}
    "base-bytes"
  ]
  build: [
    ["jbuilder" "subst" "-n" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git+https://github.com/rgrinberg/stringext.git"
  url {
    src: "https://github.com/rgrinberg/stringext/archive/1.5.0.zip"
    checksum: "md5=867263ea97532f150516677fa994cdf2"
  }*/
{ unzip, doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder,
  ounit ? null, qtest ? null, base-bytes, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.3";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta10";
assert doCheck -> stdenv.lib.versionAtLeast (stdenv.lib.getVersion qtest)
  "2.2";

stdenv.mkDerivation rec {
  pname = "stringext";
  version = "1.5.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/rgrinberg/stringext/archive/1.5.0.zip";
    sha256 = "04wdy5qlm8y4bnxxayq6fm60jmcr6490sjjxzr0dh3gypnab5ypv";
  };
  buildInputs = [
    unzip ocaml jbuilder ]
  ++
  stdenv.lib.optional
  doCheck
  ounit
  ++
  [
    qtest base-bytes findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder ]
  ++
  stdenv.lib.optional
  doCheck
  ounit
  ++
  [
    qtest base-bytes ];
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
