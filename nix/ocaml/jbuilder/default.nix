/*opam-version: "2.0"
  name: "jbuilder"
  version: "1.0+beta20"
  synopsis: "Fast, portable and opinionated build system"
  description: """
  jbuilder is a build system that was designed to simplify the release
  of Jane Street packages. It reads metadata from "jbuild" files
  following a very simple s-expression syntax.
  
  jbuilder is fast, it has very low-overhead and support parallel builds
  on all platforms. It has no system dependencies, all you need to
  build
  jbuilder and packages using jbuilder is OCaml. You don't need or make
  or bash as long as the packages themselves don't use bash
  explicitely.
  
  jbuilder supports multi-package development by simply dropping
  multiple
  repositories into the same directory.
  
  It also supports multi-context builds, such as building against
  several opam roots/switches simultaneously. This helps maintaining
  packages across several versions of OCaml and gives cross-compilation
  for free."""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/ocaml/dune"
  bug-reports: "https://github.com/ocaml/dune/issues"
  depends: [
    "ocaml" {>= "4.02.3"}
  ]
  build: [
    ["ocaml" "configure.ml" "--libdir" lib]
    ["ocaml" "bootstrap.ml"]
    ["./boot.exe" "--subst"] {pinned}
    ["./boot.exe" "-j" jobs]
  ]
  dev-repo: "git+https://github.com/ocaml/dune.git"
  url {
    src:
     
  "https://github.com/ocaml/dune/releases/download/1.0+beta20/jbuilder-1.0.beta20.tbz"
    checksum: "md5=09b8a90c6e3333aef2cac947424c1d66"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.3";

stdenv.mkDerivation rec {
  pname = "jbuilder";
  version = "1.0+beta20";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml/dune/releases/download/1.0+beta20/jbuilder-1.0.beta20.tbz";
    sha256 = "07hl9as5llffgd6hbw41rs76i1ibgn3n9r0dba5h0mdlkapcwb10";
  };
  buildInputs = [
    ocaml findlib ];
  propagatedBuildInputs = [
    ocaml ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'ocaml'" "'configure.ml'" "'--libdir'" "$OCAMLFIND_DESTDIR" ] [
      "'ocaml'" "'bootstrap.ml'" ]
    [ "'./boot.exe'" "'-j'" "1" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
