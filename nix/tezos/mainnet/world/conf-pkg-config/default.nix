/*opam-version: "2.0"
  name: "conf-pkg-config"
  version: "1.1"
  synopsis: "Virtual package relying on pkg-config installation."
  description: """
  This package can only install if the pkg-config package is installed
  on the system."""
  maintainer: "unixjunkie@sdf.org"
  authors: "Francois Berenger"
  license: "GPL"
  homepage:
  "http://www.freedesktop.org/wiki/Software/pkg-config/"
  bug-reports: "https://github.com/ocaml/opam-repository/issues"
  depends: ["ocaml"]
  flags: light-uninstall
  build: ["pkg-config" "--help"]
  install:
    ["ln" "-s" "/usr/local/bin/pkgconf" "%{bin}%/pkg-config"] {os =
  "openbsd"}
  remove: ["rm" "-f" "%{bin}%/pkg-config"] {os = "openbsd"}
  post-messages:
    "conf-pkg-config: A symlink to /usr/local/bin/pkgconf has been installed
  in the OPAM bin directory (%{bin}%) on your PATH as 'pkg-config'. This is
  necessary for correct operation."
      {os = "openbsd"}
  depexts: [
    ["pkg-config"] {os-distribution = "debian"}
    ["pkg-config"] {os-distribution = "ubuntu"}
    ["pkg-config"] {os-distribution = "archlinux"}
    ["pkgconfig"] {os-distribution = "fedora"}
    ["pkgconfig"] {os-distribution = "centos"}
    ["pkgconfig"] {os-distribution = "mageia"}
    ["pkgconfig"] {os-distribution = "rhel"}
    ["pkgconfig"] {os-distribution = "oraclelinux"}
    ["pkgconfig"] {os-distribution = "alpine"}
    ["devel/pkgconf"] {os = "freebsd"}
    ["devel/pkgconf"] {os = "openbsd"}
    ["pkg-config"] {os = "macos" & os-distribution = "homebrew"}
    ["pkgconf"] {os = "freebsd"}
  ]
  dev-repo: "git://github.com/ocaml/opam-repository"*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, pkgconfig }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in

stdenv.mkDerivation rec {
  pname = "conf-pkg-config";
  version = "1.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = (import <nixpkgs> {}).runCommand "empty" { outputHashMode = "recursive"; outputHashAlgo = "sha256"; outputHash = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5"; } "mkdir $out";
  buildInputs = [
    ocaml findlib pkgconfig ];
  propagatedBuildInputs = [
    ocaml pkgconfig ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'pkg-config'" "'--help'" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
