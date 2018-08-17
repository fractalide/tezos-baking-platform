/*opam-version: "2.0"
  name: "conf-which"
  version: "1"
  synopsis: "Virtual package relying on which"
  description:
    "This package can only install if the which program is installed on the
  system."
  maintainer: "unixjunkie@sdf.org"
  authors: "Carlo Wood"
  license: "GPL-2+"
  homepage: "http://www.gnu.org/software/which/"
  bug-reports: "https://github.com/ocaml/opam-repository/issues"
  depends: ["ocaml"]
  build: ["which" "which"]
  depexts: [
    ["which"] {os-distribution = "centos"}
    ["which"] {os-distribution = "fedora"}
    ["which"] {os-distribution = "opensuse"}
    ["debianutils"] {os-distribution = "debian"}
    ["debianutils"] {os-distribution = "ubuntu"}
    ["which"] {os-distribution = "nixos"}
    ["which"] {os-distribution = "archlinux"}
  ]
  dev-repo: "git+https://github.com/ocaml/opam-repository.git"*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, which }:

stdenv.mkDerivation rec {
  pname = "conf-which";
  version = "1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = "/var/empty";
  buildInputs = [
    ocaml findlib which ];
  propagatedBuildInputs = [
    ocaml which ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'which'" "'which'" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
