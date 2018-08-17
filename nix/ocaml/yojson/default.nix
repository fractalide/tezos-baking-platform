/*opam-version: "2.0"
  name: "yojson"
  version: "1.4.1"
  synopsis:
    "Yojson is an optimized parsing and printing library for the JSON
  format"
  description: """
  It addresses a few shortcomings of json-wheel including 2x
  speedup,
  polymorphic variants and optional syntax for tuples and variants.
  
  ydump is a pretty-printing command-line program provided with the
  yojson package.
  
  The program atdgen can be used to derive OCaml-JSON serializers
  and
  deserializers from type definitions."""
  maintainer: "martin@mjambon.com"
  authors: "Martin Jambon"
  homepage: "http://mjambon.com/yojson.html"
  bug-reports: "https://github.com/mjambon/yojson/issues"
  depends: [
    "ocaml" {>= "4.02.3"}
    "jbuilder" {build}
    "cppo" {build}
    "easy-format"
    "biniou" {>= "1.2.0"}
  ]
  build: [
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name] {with-test}
  ]
  dev-repo: "git+https://github.com/mjambon/yojson.git"
  url {
    src: "https://github.com/mjambon/yojson/archive/v1.4.1.tar.gz"
    checksum: "md5=3ea6e36422dd670e8ab880710d5f7398"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, cppo,
  easy-format, biniou, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.3";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion biniou) "1.2.0";

stdenv.mkDerivation rec {
  pname = "yojson";
  version = "1.4.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mjambon/yojson/archive/v1.4.1.tar.gz";
    sha256 = "1yqicsz65qvi82pp4x970lcf3bzdyn64ckv1qk5dpg83bb5si0f0";
  };
  buildInputs = [
    ocaml jbuilder cppo easy-format biniou findlib ];
  propagatedBuildInputs = [
    ocaml easy-format biniou ];
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
