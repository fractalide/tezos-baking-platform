/*opam-version: "2.0"
  name: "cmdliner"
  version: "1.0.2"
  synopsis: "Declarative definition of command line interfaces for
  OCaml"
  description: """
  Cmdliner allows the declarative definition of command line interfaces
  for OCaml.
  
  It provides a simple and compositional mechanism to convert command
  line arguments to OCaml values and pass them to your functions. The
  module automatically handles syntax errors, help messages and UNIX man
  page generation. It supports programs with single or multiple commands
  and respects most of the [POSIX][1] and [GNU][2] conventions.
  
  Cmdliner has no dependencies and is distributed under the ISC license.
  
  [1]:
  http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap12.html
  [2]:
  http://www.gnu.org/software/libc/manual/html_node/Argument-Syntax.html"""
  maintainer: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  authors: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  license: "ISC"
  tags: ["cli" "system" "declarative" "org:erratique"]
  homepage: "http://erratique.ch/software/cmdliner"
  doc: "http://erratique.ch/software/cmdliner/doc/Cmdliner"
  bug-reports: "https://github.com/dbuenzli/cmdliner/issues"
  depends: [
    "ocaml" {>= "4.01.0"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build}
    "result"
  ]
  build: ["ocaml" "pkg/pkg.ml" "build" "--pinned" "%{pinned}%"]
  dev-repo: "git+http://erratique.ch/repos/cmdliner.git"
  url {
    src: "http://erratique.ch/software/cmdliner/releases/cmdliner-1.0.2.tbz"
    checksum: "md5=ab2f0130e88e8dcd723ac6154c98a881"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  result }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01.0";

stdenv.mkDerivation rec {
  pname = "cmdliner";
  version = "1.0.2";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://erratique.ch/software/cmdliner/releases/cmdliner-1.0.2.tbz";
    sha256 = "18jqphjiifljlh9jg8zpl6310p3iwyaqphdkmf89acyaix0s4kj1";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg result ];
  propagatedBuildInputs = [
    ocaml result ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
