/*opam-version: "2.0"
  name: "ppx_metaquot"
  version: "v0.10.0"
  synopsis: "Write OCaml AST fragment using OCaml syntax"
  description: """
  Ppx_metaquot is a ppx rewriter allowing you to write values
  representing the OCaml AST in the OCaml syntax."""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/ppx_metaquot"
  bug-reports: "https://github.com/janestreet/ppx_metaquot/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "ppx_core" {>= "v0.10" & < "v0.11"}
    "ppx_driver" {>= "v0.10" & < "v0.11"}
    "ppx_traverse_builtins" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
    "ocaml-migrate-parsetree" {>= "0.4"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/ppx_metaquot.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_metaquot-v0.10.0.tar.gz"
    checksum: [
      "md5=0286e294ae66d43577fa4cf4cecd6069"
     
  "sha256=8cbfb44b2ae77a0178159a7d07713231e99dfbfa01c629a4767e9d2c9bc9c3a8"
     
  "sha512=90d531f8749dadfcc1c955639a6eb2a88c6f43796a62ef830f8b744d744bb8872031c7e6eaab327cfae4e71db42b1631e3202fee8fe53d6e695756bbf47bfd37"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, ppx_core, ppx_driver,
  ppx_traverse_builtins, jbuilder, ocaml-migrate-parsetree, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.04.1") >= 0;
assert (vcompare ppx_core "v0.10") >= 0 && (vcompare ppx_core "v0.11") < 0;
assert (vcompare ppx_driver "v0.10") >= 0 && (vcompare ppx_driver "v0.11") <
  0;
assert (vcompare ppx_traverse_builtins "v0.10") >= 0 && (vcompare
  ppx_traverse_builtins "v0.11") < 0;
assert (vcompare jbuilder "1.0+beta12") >= 0;
assert (vcompare ocaml-migrate-parsetree "0.4") >= 0;

stdenv.mkDerivation rec {
  pname = "ppx_metaquot";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_metaquot-v0.10.0.tar.gz";
    sha256 = "1a63r6djr7byfsj2kih1zbxrvs9i69qhfzcs2mw02yp7595v9gwc";
  };
  buildInputs = [
    ocaml ppx_core ppx_driver ppx_traverse_builtins jbuilder
    ocaml-migrate-parsetree findlib ];
  propagatedBuildInputs = [
    ocaml ppx_core ppx_driver ppx_traverse_builtins jbuilder
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
