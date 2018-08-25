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
    checksum: [
      "md5=5cd5d766679ff1ef6ad846e653b8ceb2"
     
  "sha256=da52af0535d5fa97be12bc756401f4a93cb0c29b36cb62c77aa38639f40b2807"
     
  "sha512=e91fe57fda45af72726eb16568e2c771f0d8f323837d4db85f8380d160ef26832e0c0a87aea9ff4c16475d5803c88d446d39469969f85806df6d99faf4f7282f"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, fieldslib, ppx_core,
  ppx_driver, ppx_metaquot, ppx_type_conv, jbuilder, ocaml-migrate-parsetree,
  findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.04.1") >= 0;
assert (vcompare fieldslib "v0.10") >= 0 && (vcompare fieldslib "v0.11") < 0;
assert (vcompare ppx_core "v0.10") >= 0 && (vcompare ppx_core "v0.11") < 0;
assert (vcompare ppx_driver "v0.10") >= 0 && (vcompare ppx_driver "v0.11") <
  0;
assert (vcompare ppx_metaquot "v0.10") >= 0 && (vcompare ppx_metaquot
  "v0.11") < 0;
assert (vcompare ppx_type_conv "v0.10") >= 0 && (vcompare ppx_type_conv
  "v0.11") < 0;
assert (vcompare jbuilder "1.0+beta12") >= 0;
assert (vcompare ocaml-migrate-parsetree "0.4") >= 0;

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
