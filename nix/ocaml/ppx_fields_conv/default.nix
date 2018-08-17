/*opam-version: "2.0"
  name: "ppx_fields_conv"
  version: "v0.10.0"
  synopsis: "Generation of accessor and iteration functions for ocaml
  records"
  description: "Part of the Jane Street's PPX rewriters
  collection."
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/ppx_fields_conv"
  bug-reports: "https://github.com/janestreet/ppx_fields_conv/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "fieldslib" {>= "v0.10" & < "v0.11"}
    "ppx_core" {>= "v0.10" & < "v0.11"}
    "ppx_driver" {>= "v0.10" & < "v0.11"}
    "ppx_metaquot" {>= "v0.10" & < "v0.11"}
    "ppx_type_conv" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
    "ocaml-migrate-parsetree" {>= "0.4"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/ppx_fields_conv.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_fields_conv-v0.10.0.tar.gz"
    checksum: "md5=5cd5d766679ff1ef6ad846e653b8ceb2"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, fieldslib, ppx_core,
  ppx_driver, ppx_metaquot, ppx_type_conv, jbuilder, ocaml-migrate-parsetree,
  findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.04.1";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion fieldslib) "v0.10" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion fieldslib) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_core) "v0.10" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion ppx_core) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_driver) "v0.10"
  && stdenv.lib.versionOlder (stdenv.lib.getVersion ppx_driver) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_metaquot) 
  "v0.10" && stdenv.lib.versionOlder (stdenv.lib.getVersion ppx_metaquot)
  "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_type_conv)
  "v0.10" && stdenv.lib.versionOlder (stdenv.lib.getVersion ppx_type_conv)
  "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta12";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion
  ocaml-migrate-parsetree) "0.4";

stdenv.mkDerivation rec {
  pname = "ppx_fields_conv";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_fields_conv-v0.10.0.tar.gz";
    sha256 = "01r81gs3k1m3gb3n5jrnkg1b0g59yh0n8xdw2az9gynm6l2sylns";
  };
  buildInputs = [
    ocaml fieldslib ppx_core ppx_driver ppx_metaquot ppx_type_conv jbuilder
    ocaml-migrate-parsetree findlib ];
  propagatedBuildInputs = [
    ocaml fieldslib ppx_core ppx_driver ppx_metaquot ppx_type_conv jbuilder
    ocaml-migrate-parsetree ];
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
