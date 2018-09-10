/*opam-version: "2.0"
  name: "fieldslib"
  version: "v0.10.0"
  synopsis:
    "Syntax extension to define first class values representing record
  fields, to get and set record fields, iterate and fold over all fields of a
  record and create new record values"
  description: """
  Part of Jane Street's Core library
  The Core suite of libraries is an industrial strength alternative to
  OCaml's standard library that was developed by Jane Street, the
  largest industrial user of OCaml."""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/fieldslib"
  bug-reports: "https://github.com/janestreet/fieldslib/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "base" {>= "v0.10" & < "v0.11"}
    "ppx_driver" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
    "ocaml-migrate-parsetree" {>= "0.4"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/fieldslib.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/fieldslib-v0.10.0.tar.gz"
    checksum: "md5=c2cd9e061a0cee73b2909d1d56f3d8f3"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, base, ppx_driver, jbuilder,
  ocaml-migrate-parsetree, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.04.1";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion base) "v0.10" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion base) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_driver) "v0.10"
  && stdenv.lib.versionOlder (stdenv.lib.getVersion ppx_driver) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta12";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion
  ocaml-migrate-parsetree) "0.4";

stdenv.mkDerivation rec {
  pname = "fieldslib";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/fieldslib-v0.10.0.tar.gz";
    sha256 = "0zw6b14hs1lf75z7cmv7xmy3hwjm7ynli4c6zbj8yqi8f5lhkif1";
  };
  buildInputs = [
    ocaml base ppx_driver jbuilder ocaml-migrate-parsetree findlib ];
  propagatedBuildInputs = [
    ocaml base ppx_driver jbuilder ocaml-migrate-parsetree ];
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
