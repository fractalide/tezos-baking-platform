/*opam-version: "2.0"
  name: "bigstring"
  version: "0.2"
  synopsis: "Bigstring built on top of bigarrays, and convenient
  functions"
  description: """
  Bigstrings are useful for interfacing with C, low level IO,
  memory-mapping, etc."""
  maintainer: "Simon Cruanes <simon.cruanes.2007@m4x.org>"
  authors: "Simon Cruanes <simon.cruanes.2007@m4x.org>"
  tags: ["bigstring" "bigarray"]
  homepage: "https://github.com/c-cube/ocaml-bigstring/"
  bug-reports: "https://github.com/c-cube/ocaml-bigstring/issues"
  depends: [
    "ocaml" {>= "4.03.0"}
    "jbuilder" {build & >= "1.0+beta19.1"}
    "base-bigarray"
    "base-bytes"
  ]
  build: [
    ["jbuilder" "build" "-j" jobs "-p" name "@install"]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git://github.com/c-cube/ocaml-bigstring"
  url {
    src: "https://github.com/c-cube/ocaml-bigstring/archive/0.2.tar.gz"
    checksum: "md5=5582e995b7d4c9e4a2949214756db7dd"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, base-bigarray,
  base-bytes, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.03.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta19.1";

stdenv.mkDerivation rec {
  pname = "bigstring";
  version = "0.2";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/c-cube/ocaml-bigstring/archive/0.2.tar.gz";
    sha256 = "01pkd2m68pyplx15zlrrlr5ys59rgq6x6kwdz6c8njv4n8rqvrnf";
  };
  buildInputs = [
    ocaml jbuilder base-bigarray base-bytes findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder base-bigarray base-bytes ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-j'" "1" "'-p'" pname "'@install'" ]
    (stdenv.lib.optionals doCheck [
      "'jbuilder'" "'runtest'" "'-p'" pname "'-j'" "1" ])
    ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
