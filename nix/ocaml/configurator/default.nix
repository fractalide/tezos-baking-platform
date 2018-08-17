/*opam-version: "2.0"
  name: "configurator"
  version: "v0.10.0"
  synopsis: "Helper library for gathering system configuration"
  description: """
  Configurator is a small library that helps writing OCaml scripts that
  test features available on the system, in order to generate config.h
  files for instance.
  
  Configurator allows one to:
  - test if a C program compiles
  - query pkg-config
  - import #define from OCaml header files
  - generate config.h file"""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/configurator"
  bug-reports: "https://github.com/janestreet/configurator/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "base" {>= "v0.10" & < "v0.11"}
    "stdio" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/configurator.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/configurator-v0.10.0.tar.gz"
    checksum: "md5=d02f66dd5dc4dbc3017f78c51209ba6b"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, base, stdio, jbuilder,
  findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.04.1";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion base) "v0.10" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion base) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion stdio) "v0.10" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion stdio) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta12";

stdenv.mkDerivation rec {
  pname = "configurator";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/configurator-v0.10.0.tar.gz";
    sha256 = "0cvnkhzd3zwnc93ppg9qc9cklw0hi189irr19s3g6r6nszims1fq";
  };
  buildInputs = [
    ocaml base stdio jbuilder findlib ];
  propagatedBuildInputs = [
    ocaml base stdio jbuilder ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
