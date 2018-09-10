/*opam-version: "2.0"
  name: "ppx_ast"
  version: "v0.10.0"
  synopsis: "OCaml AST used by Jane Street ppx rewriters"
  description: """
  Ppx_ast selects a specific version of the OCaml Abstract Syntax Tree
  from the migrate-parsetree project that is not necessarily the same
  one as the one being used by the compiler.
  
  It also snapshots the corresponding parser and pretty-printer from the
  OCaml compiler, to create a full frontend independent of the version
  of OCaml."""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/ppx_ast"
  bug-reports: "https://github.com/janestreet/ppx_ast/issues"
  depends: [
    "ocaml" {>= "4.04.1" & < "4.07.0"}
    "ocaml-compiler-libs" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
    "ocaml-migrate-parsetree" {>= "0.4"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/ppx_ast.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_ast-v0.10.0.tar.gz"
    checksum: "md5=8853cb32dd6c22365283156ed6f54622"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, ocaml-compiler-libs,
  jbuilder, ocaml-migrate-parsetree, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.04.1" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion ocaml) "4.07.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml-compiler-libs)
  "v0.10" && stdenv.lib.versionOlder (stdenv.lib.getVersion
  ocaml-compiler-libs) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta12";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion
  ocaml-migrate-parsetree) "0.4";

stdenv.mkDerivation rec {
  pname = "ppx_ast";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_ast-v0.10.0.tar.gz";
    sha256 = "0sch3nylc0yscbdzg9sbxrnfx38m0m0sxmjzplhx7i5pvwzgj5xj";
  };
  buildInputs = [
    ocaml ocaml-compiler-libs jbuilder ocaml-migrate-parsetree findlib ];
  propagatedBuildInputs = [
    ocaml ocaml-compiler-libs jbuilder ocaml-migrate-parsetree ];
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
