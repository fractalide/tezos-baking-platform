/*opam-version: "2.0"
  name: "ppx_type_conv"
  version: "v0.10.0"
  synopsis: "Support Library for type-driven code generators"
  description: "Part of the Jane Street's PPX rewriters
  collection."
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/ppx_type_conv"
  bug-reports: "https://github.com/janestreet/ppx_type_conv/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "ppx_core" {>= "v0.10" & < "v0.11"}
    "ppx_driver" {>= "v0.10" & < "v0.11"}
    "ppx_metaquot" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
    "ocaml-migrate-parsetree" {>= "0.4"}
    "ppx_derivers"
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/ppx_type_conv.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_type_conv-v0.10.0.tar.gz"
    checksum: "md5=ae87662d39eebc6a2df6851c0f4da88c"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, ppx_core, ppx_driver,
  ppx_metaquot, jbuilder, ocaml-migrate-parsetree, ppx_derivers, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.04.1";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_core) "v0.10" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion ppx_core) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_driver) "v0.10"
  && stdenv.lib.versionOlder (stdenv.lib.getVersion ppx_driver) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_metaquot) 
  "v0.10" && stdenv.lib.versionOlder (stdenv.lib.getVersion ppx_metaquot)
  "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta12";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion
  ocaml-migrate-parsetree) "0.4";

stdenv.mkDerivation rec {
  pname = "ppx_type_conv";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_type_conv-v0.10.0.tar.gz";
    sha256 = "0g3zydbfn3c4z5kkdisn6k9sbdi00kg86yjsdy9402nm42fxfxh9";
  };
  buildInputs = [
    ocaml ppx_core ppx_driver ppx_metaquot jbuilder ocaml-migrate-parsetree
    ppx_derivers findlib ];
  propagatedBuildInputs = [
    ocaml ppx_core ppx_driver ppx_metaquot jbuilder ocaml-migrate-parsetree
    ppx_derivers ];
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
