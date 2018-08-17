/*opam-version: "2.0"
  name: "ocamlgraph"
  version: "1.8.8"
  synopsis: "A generic graph library for OCaml"
  maintainer: "filliatr@lri.fr"
  authors: ["Sylvain Conchon" "Jean-Christophe Filliâtre" "Julien
  Signoles"]
  license: "GNU Library General Public License version 2.1"
  tags: [
    "graph"
    "library"
    "algorithms"
    "directed graph"
    "vertice"
    "edge"
    "persistent"
    "imperative"
  ]
  homepage: "http://ocamlgraph.lri.fr/"
  doc: "http://ocamlgraph.lri.fr/doc"
  bug-reports: "https://github.com/backtracking/ocamlgraph/issues"
  depends: [
    "ocaml"
    "ocamlfind" {build}
  ]
  depopts: ["lablgtk" "conf-gnomecanvas"]
  flags: light-uninstall
  build: [
    ["touch" "./configure"]
    ["./configure"]
    [make]
  ]
  install: [make "install-findlib"]
  remove: ["ocamlfind" "remove" "ocamlgraph"]
  dev-repo: "git+https://github.com/backtracking/ocamlgraph.git"
  url {
    src: "http://ocamlgraph.lri.fr/download/ocamlgraph-1.8.8.tar.gz"
    checksum: "md5=9d71ca69271055bd22d0dfe4e939831a"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, lablgtk ? null,
  conf-gnomecanvas ? null }:

stdenv.mkDerivation rec {
  pname = "ocamlgraph";
  version = "1.8.8";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://ocamlgraph.lri.fr/download/ocamlgraph-1.8.8.tar.gz";
    sha256 = "0m9g16wrrr86gw4fz2fazrh8nkqms0n863w7ndcvrmyafgxvxsnr";
  };
  buildInputs = [
    ocaml findlib ]
  ++
  stdenv.lib.optional
  (lablgtk
  !=
  null)
  lablgtk
  ++
  stdenv.lib.optional
  (conf-gnomecanvas
  !=
  null)
  conf-gnomecanvas;
  propagatedBuildInputs = [
    ocaml ]
  ++
  stdenv.lib.optional
  (lablgtk
  !=
  null)
  lablgtk
  ++
  stdenv.lib.optional
  (conf-gnomecanvas
  !=
  null)
  conf-gnomecanvas;
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'touch'" "'./configure'" ] [ "'./configure'" ] [ "make" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'install-findlib'" ] ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
