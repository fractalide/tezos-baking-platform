/*opam-version: "2.0"
  name: "opam-depext"
  version: "1.1.2"
  synopsis: "Query and install external dependencies of OPAM
  packages"
  description: """
  opam-depext is a simple program intended to facilitate the interaction
  between
  OPAM packages and the host package management system. It can query OPAM for
  the
  right external dependencies on a set of packages, depending on the host OS,
  and
  call the OS's package manager in the appropriate way to install
  them."""
  maintainer: [
    "Louis Gesbert <louis.gesbert@ocamlpro.com>"
    "Anil Madhavapeddy <anil@recoil.org>"
  ]
  authors: [
    "Louis Gesbert <louis.gesbert@ocamlpro.com>"
    "Anil Madhavapeddy <anil@recoil.org>"
  ]
  license: "LGPL-2.1 with OCaml linking exception"
  homepage: "https://github.com/ocaml/opam-depext"
  bug-reports: "https://github.com/ocaml/opam-depext/issues"
  depends: ["ocaml"]
  available: opam-version >= "2.0.0~beta5"
  flags: plugin
  build: make
  dev-repo: "git+https://github.com/ocaml/opam-depext.git#2.0"
  url {
    src:
     
  "https://github.com/ocaml/opam-depext/releases/download/v1.1.2/opam-depext-full-1.1.2.tbz"
    checksum: "md5=d71c9c0ada811ccf0669d09e1b0329da"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:

stdenv.mkDerivation rec {
  pname = "opam-depext";
  version = "1.1.2";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml/opam-depext/releases/download/v1.1.2/opam-depext-full-1.1.2.tbz";
    sha256 = "1c5rd5ar6d7clz02hp2jj8zmh4cawcfg60gf7m8rxlswhvp1vq9r";
  };
  buildInputs = [
    ocaml findlib ];
  propagatedBuildInputs = [
    ocaml ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
