/*opam-version: "2.0"
  name: "conf-libev"
  version: "4-11"
  synopsis: "High-performance event loop/event model with lots of
  features"
  description: """
  Libev is modelled (very loosely) after libevent and the Event perl
  module, but is faster, scales better and is more correct, and also
  more
  featureful. And also smaller. Yay."""
  maintainer: "https://github.com/ocaml/opam-repository/issues"
  depends: ["ocaml"]
  build: ["sh" "./build.sh"]
  depexts: [
    ["libev-dev"] {os-distribution = "debian"}
    ["libev-dev"] {os-distribution = "ubuntu"}
    ["libev"] {os = "macos" & os-distribution = "homebrew"}
    ["libev-dev"] {os-distribution = "alpine"}
    ["libev"] {os-distribution = "archlinux"}
    ["libev-devel"] {os-distribution = "fedora"}
    ["libev-devel"] {os-distribution = "rhel"}
    ["libev-devel"] {os-distribution = "centos"}
    ["libev-devel"] {os-distribution = "opensuse"}
    ["libev"] {os = "freebsd"}
    ["libev"] {os = "openbsd"}
    ["libev"] {os-distribution = "archlinux"}
  ]
  extra-files: [
    ["discover.ml" "md5=45c6a7a77eac449e1214235a3407a344"]
    ["build.sh" "md5=f37b5eb73ebeb177dff1cd8bb2f38c4e"]
  ]*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, libev, ncurses }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in

stdenv.mkDerivation rec {
  pname = "conf-libev";
  version = "4-11";
  name = "${pname}-${version}";
  inherit doCheck;
  src = (import <nixpkgs> {}).runCommand "empty" {} "mkdir $out";
  postUnpack = "ln -sv ${./discover.ml} \"$sourceRoot\"/discover.ml\nln -sv ${./build.sh} \"$sourceRoot\"/build.sh";
  buildInputs = [ ocaml findlib libev ncurses ];
  propagatedBuildInputs = [ ocaml libev ];
  configurePhase = "true";
  buildPhase = "C_INCLUDE_PATH=${libev}/include LIBRARY_PATH=${libev}/lib sh ./build.sh";
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
