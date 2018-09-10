/*opam-version: "2.0"
  name: "ppx_tools_versioned"
  version: "5.1"
  synopsis: "A variant of ppx_tools based on
  ocaml-migrate-parsetree"
  maintainer: "frederic.bour@lakaban.net"
  authors: [
    "Frédéric Bour <frederic.bour@lakaban.net>"
    "Alain Frisch <alain.frisch@lexifi.com>"
  ]
  license: "MIT"
  tags: "syntax"
  homepage: "https://github.com/let-def/ppx_tools_versioned"
  bug-reports:
  "https://github.com/let-def/ppx_tools_versioned/issues"
  depends: [
    "ocaml" {>= "4.02.0"}
    "ocamlfind" {>= "1.5.0"}
    "ocaml-migrate-parsetree" {>= "1.0.7"}
  ]
  flags: light-uninstall
  build: [make "all"]
  install: [make "install"]
  remove: ["ocamlfind" "remove" "ppx_tools_versioned"]
  dev-repo: "git://github.com/let-def/ppx_tools_versioned.git"
  url {
    src:
  "https://github.com/ocaml-ppx/ppx_tools_versioned/archive/5.1.tar.gz"
    checksum: "md5=e48cc87d6da6c2f3020fd8dfe8fe50de"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib,
  ocaml-migrate-parsetree }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion findlib) "1.5.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion
  ocaml-migrate-parsetree) "1.0.7";

stdenv.mkDerivation rec {
  pname = "ppx_tools_versioned";
  version = "5.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml-ppx/ppx_tools_versioned/archive/5.1.tar.gz";
    sha256 = "0qawkgvr6mb801ag7dw7jck0znn8rg37pvmmi1h0zbwf71wfbfph";
  };
  buildInputs = [
    ocaml findlib ocaml-migrate-parsetree ];
  propagatedBuildInputs = [
    ocaml findlib ocaml-migrate-parsetree ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'all'" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'install'" ] ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
