/*opam-version: "2.0"
  name: "ocaml-migrate-parsetree"
  version: "1.0.11"
  synopsis: "Convert OCaml parsetrees between different versions"
  description: """
  This library converts parsetrees, outcometree and ast mappers between
  different OCaml versions.
  High-level functions help making PPX rewriters independent of a compiler
  version."""
  maintainer: "frederic.bour@lakaban.net"
  authors: [
    "Frédéric Bour <frederic.bour@lakaban.net>"
    "Jérémie Dimino <jeremie@dimino.org>"
  ]
  license: "LGPL-2.1"
  tags: ["syntax" "org:ocamllabs"]
  homepage:
  "https://github.com/ocaml-ppx/ocaml-migrate-parsetree"
  bug-reports:
  "https://github.com/ocaml-ppx/ocaml-migrate-parsetree/issues"
  depends: [
    "ocaml" {>= "4.02.0"}
    "result"
    "ocamlfind" {build}
    "jbuilder" {build & >= "1.0+beta18.1"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git://github.com/ocaml-ppx/ocaml-migrate-parsetree.git"
  url {
    src:
     
  "https://github.com/ocaml-ppx/ocaml-migrate-parsetree/releases/download/v1.0.11/ocaml-migrate-parsetree-1.0.11.tbz"
    checksum: "md5=26bb1b038de81a79d43ed95c282b2b71"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, result, findlib, jbuilder
  }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta18.1";

stdenv.mkDerivation rec {
  pname = "ocaml-migrate-parsetree";
  version = "1.0.11";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml-ppx/ocaml-migrate-parsetree/releases/download/v1.0.11/ocaml-migrate-parsetree-1.0.11.tbz";
    sha256 = "0ski0ljb5cppabw0kxaxh1j94gzf7v2a76kvwwxh55qqm96d95nq";
  };
  buildInputs = [
    ocaml result findlib jbuilder ];
  propagatedBuildInputs = [
    ocaml result jbuilder ];
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
