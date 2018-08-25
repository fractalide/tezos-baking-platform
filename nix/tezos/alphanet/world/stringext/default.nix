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
    ["jbuilder" "subst" "-p" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git+https://github.com/rgrinberg/stringext.git"
  url {
    src: "https://github.com/rgrinberg/stringext/archive/1.5.0.zip"
    checksum: [
      "md5=867263ea97532f150516677fa994cdf2"
     
  "sha256=fbfab294bdfe0dd840fe5d4a0d12319955094c75067bd5bb5dc4a34a71f18d13"
     
  "sha512=f415fb19e5b4158de9f52c8aec4bd6f2f674672cc0f3a2ed557b13fce72bbeaa103e0185ae1f44c274a16a2d19677fb8f9dc255af0319a3afd0d5c223b50cee2"
    ]
  }*/
{ unzip, doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder,
  ounit ? null, qtest ? null, base-bytes, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.3") >= 0;
assert (vcompare jbuilder "1.0+beta10") >= 0;
assert doCheck -> (vcompare qtest "2.2") >= 0;

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
