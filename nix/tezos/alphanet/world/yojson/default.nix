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
    checksum: [
      "md5=3ea6e36422dd670e8ab880710d5f7398"
     
  "sha256=c081a8cb5a03bddbcac4614f468cf5edafe11805277572af4071e362be6611fb"
     
  "sha512=9175f2a26993467e587a44ef8af9dba767370536204f0ec56196769c206f92edc27bdfa89b543f90ed33c8a9abaad3342b5296ac5e49d3d7a27561c1cce818d0"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, cppo,
  easy-format, biniou, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.3") >= 0;
assert (vcompare biniou "1.2.0") >= 0;

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
