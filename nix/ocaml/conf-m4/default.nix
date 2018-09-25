/*opam-version: "2.0"
  name: "conf-m4"
  version: "1"
  synopsis: "Virtual package relying on m4"
  description:
    "This package can only install if the m4 binary is installed on the
  system."
  maintainer: "tim@gfxmonk.net"
  license: "GPL-3"
  homepage: "http://www.gnu.org/software/m4/m4.html"
  bug-reports: "https://github.com/ocaml/opam-repository/issues"
  depends: ["ocaml"]
  build: ["sh" "-exc" "echo | m4"]
  depexts: [
    ["m4"] {os-distribution = "debian"}
    ["m4"] {os-distribution = "ubuntu"}
    ["m4"] {os-distribution = "fedora"}
    ["m4"] {os-distribution = "rhel"}
    ["m4"] {os-distribution = "centos"}
    ["m4"] {os-distribution = "alpine"}
    ["m4"] {os-distribution = "nixos"}
    ["m4"] {os-distribution = "opensuse"}
    ["m4"] {os-distribution = "oraclelinux"}
    ["m4"] {os-distribution = "archlinux"}
  ]
  dev-repo: "git+https://github.com/ocaml/opam-repository.git"*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, m4 }:

stdenv.mkDerivation rec {
  pname = "conf-m4";
  version = "1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = (import <nixpkgs> {}).runCommand "empty" {} "mkdir $out";
  buildInputs = [
    ocaml findlib m4 ];
  propagatedBuildInputs = [
    ocaml m4 ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'sh'" "'-exc'" "'echo | m4'" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
