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
    ["hidapi"] {os-distribution = "nixos"}
  ]
  dev-repo: "git://github.com/ocaml/opam-repository.git"*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, conf-pkg-config, findlib,
  hidapi }:

stdenv.mkDerivation rec {
  pname = "conf-hidapi";
  version = "0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = (import <nixpkgs> {}).runCommand "empty" { outputHashMode = "recursive"; outputHashAlgo = "sha256"; outputHash = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5"; } "mkdir $out";
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
