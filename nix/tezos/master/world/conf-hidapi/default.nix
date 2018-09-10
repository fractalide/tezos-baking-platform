/*opam-version: "2.0"
  name: "conf-hidapi"
  version: "0"
  synopsis: "Virtual package relying on a hidapi system
  installation."
  description:
    "This package can only install if the hidapi lib is installed on the
  system."
  maintainer: "Vincent Bernardoff"
  authors: "Signal 11 Software"
  license: "BSD"
  homepage: "http://www.signal11.us/oss/hidapi/"
  bug-reports: "https://github.com/ocaml/opam-repository/issues"
  depends: [
    "ocaml"
    "conf-pkg-config" {build}
  ]
  build: [
    ["pkg-config" "hidapi-libusb"] {os != "macos"}
    ["pkg-config" "hidapi"] {os = "macos"}
  ]
  depexts: [
    ["libhidapi-dev"] {os-distribution = "ubuntu"}
    ["libhidapi-dev"] {os-distribution = "debian"}
    ["hidapi"] {os-distribution = "archlinux"}
    ["hidapi"] {os = "macos" & os-distribution = "homebrew"}
    ["hidapi-dev"] {os-distribution = "alpine"}
    ["epel-release" "hidapi-devel"] {os-distribution = "centos"}
  ]
  dev-repo: "git://github.com/ocaml/opam-repository.git"*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, conf-pkg-config, findlib,
  hidapi }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in

stdenv.mkDerivation rec {
  pname = "conf-hidapi";
  version = "0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = "/var/empty";
  buildInputs = [
    ocaml conf-pkg-config findlib hidapi ];
  propagatedBuildInputs = [
    ocaml hidapi ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'pkg-config'" "'hidapi-libusb'" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
