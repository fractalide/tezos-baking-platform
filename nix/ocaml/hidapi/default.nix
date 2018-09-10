/*opam-version: "2.0"
  name: "hidapi"
  version: "1.0-1"
  synopsis:
    "A Simple library for communicating with USB and Bluetooth HID devices on
  Linux, Mac, and Windows."
  maintainer: "Vincent Bernardoff <vb@luminar.eu.org>"
  authors: "Vincent Bernardoff <vb@luminar.eu.org>"
  homepage: "https://github.com/vbmithr/ocaml-hidapi"
  bug-reports: "https://github.com/vbmithr/ocaml-hidapi/issues"
  depends: [
    "ocaml" {>= "4.02.0"}
    "jbuilder" {build & >= "1.0+beta13"}
    "configurator" {build & >= "v0.10.0"}
    "conf-hidapi" {build}
    "bigstring" {>= "0.1.1"}
  ]
  build: ["jbuilder" "build" "-j" jobs "-p" name "@install"]
  dev-repo: "git://github.com/vbmithr/ocaml-hidapi"
  url {
    src: "https://github.com/vbmithr/ocaml-hidapi/archive/1.0.tar.gz"
    checksum: "md5=6197689cd0d5eae5316a4a2ba2a6f79f"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, configurator,
  conf-hidapi, bigstring, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta13";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion configurator)
  "v0.10.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion bigstring) "0.1.1";

stdenv.mkDerivation rec {
  pname = "hidapi";
  version = "1.0-1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/vbmithr/ocaml-hidapi/archive/1.0.tar.gz";
    sha256 = "1ckd0i2p7w8z3ffvmka6zyxa33a3jxkdisk35lvir8dgbs3fga1y";
  };
  buildInputs = [
    ocaml jbuilder configurator conf-hidapi bigstring findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder configurator bigstring ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-j'" "1" "'-p'" pname "'@install'" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
