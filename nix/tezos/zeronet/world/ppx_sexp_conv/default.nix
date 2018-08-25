/*opam-version: "2.0"
  name: "ppx_sexp_conv"
  version: "v0.10.0"
  synopsis:
    "Generation of S-expression conversion functions from type
  definitions"
  description: "Part of the Jane Street's PPX rewriters
  collection."
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/ppx_sexp_conv"
  bug-reports: "https://github.com/janestreet/ppx_sexp_conv/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "ppx_core" {>= "v0.10" & < "v0.11"}
    "ppx_driver" {>= "v0.10" & < "v0.11"}
    "ppx_metaquot" {>= "v0.10" & < "v0.11"}
    "ppx_type_conv" {>= "v0.10" & < "v0.11"}
    "sexplib" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
    "ocaml-migrate-parsetree" {>= "0.4"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/ppx_sexp_conv.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_sexp_conv-v0.10.0.tar.gz"
    checksum: [
      "md5=c14ca06337e21899ee9ea32cf52aa374"
     
  "sha256=e5b1e8c3fba3dfd3bd0e38c42fd85bf1e31538009a9325bb4209a41d2395e2ce"
     
  "sha512=25039156af80764399d9ce94e74fd1e9124d64cee1d2639cbfd81367f1f89f07cebfe12a3a5d21503216db28e46c53466416c0bf5bec4798b1f1e73c35abec1f"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, ppx_core, ppx_driver,
  ppx_metaquot, ppx_type_conv, sexplib, jbuilder, ocaml-migrate-parsetree,
  findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.04.1") >= 0;
assert (vcompare ppx_core "v0.10") >= 0 && (vcompare ppx_core "v0.11") < 0;
assert (vcompare ppx_driver "v0.10") >= 0 && (vcompare ppx_driver "v0.11") <
  0;
assert (vcompare ppx_metaquot "v0.10") >= 0 && (vcompare ppx_metaquot
  "v0.11") < 0;
assert (vcompare ppx_type_conv "v0.10") >= 0 && (vcompare ppx_type_conv
  "v0.11") < 0;
assert (vcompare sexplib "v0.10") >= 0 && (vcompare sexplib "v0.11") < 0;
assert (vcompare jbuilder "1.0+beta12") >= 0;
assert (vcompare ocaml-migrate-parsetree "0.4") >= 0;

stdenv.mkDerivation rec {
  pname = "ppx_sexp_conv";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_sexp_conv-v0.10.0.tar.gz";
    sha256 = "1kp2jliiv9098axjb4ws00w1bqzibgc2zi1q1syx7px3zg1yicg5";
  };
  buildInputs = [
    ocaml ppx_core ppx_driver ppx_metaquot ppx_type_conv sexplib jbuilder
    ocaml-migrate-parsetree findlib ];
  propagatedBuildInputs = [
    ocaml ppx_core ppx_driver ppx_metaquot ppx_type_conv sexplib jbuilder
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
