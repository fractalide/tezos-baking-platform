/*opam-version: "2.0"
  name: "conf-gmp"
  version: "1"
  synopsis: "Virtual package relying on a GMP lib system
  installation."
  description:
    "This package can only install if the GMP lib is installed on the
  system."
  maintainer: "nbraud"
  authors: "nbraud"
  license: "GPL"
  homepage: "http://gmplib.org/"
  bug-reports: "https://github.com/ocaml/opam-repository/issues"
  depends: ["ocaml"]
  build: [
    ["sh" "-exc" "cc -c $CFLAGS -I/usr/local/include test.c"] {os != "macos"}
    [
      "sh"
      "-exc"
      "cc -c $CFLAGS -I/opt/local/include -I/usr/local/include test.c"
    ] {os = "macos"}
  ]
  depexts: [
    ["libgmp-dev"] {os-distribution = "debian"}
    ["libgmp-dev"] {os-distribution = "ubuntu"}
    ["gmp"] {os = "macos" & os-distribution = "homebrew"}
    ["gmp" "gmp-devel"] {os-distribution = "centos"}
    ["gmp" "gmp-devel"] {os-distribution = "fedora"}
    ["gmp"] {os = "openbsd"}
    ["gmp"] {os = "freebsd"}
    ["gmp-dev"] {os-distribution = "alpine"}
    ["gmp-devel"] {os-distribution = "opensuse"}
    ["gmp"] {os-distribution = "nixos"}
  ]
  dev-repo: "git+https://github.com/ocaml/opam-repository.git"
  extra-files: ["test.c" "md5=ec8cc21ab709bdd57103de36e7b0b53f"]*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, gmp }:

stdenv.mkDerivation rec {
  pname = "conf-gmp";
  version = "1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = (import <nixpkgs> {}).runCommand "empty" { outputHashMode = "recursive"; outputHashAlgo = "sha256"; outputHash = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5"; } "mkdir $out";
  postUnpack = "ln -sv ${./test.c} \"$sourceRoot\"/test.c";
  buildInputs = [
    ocaml findlib gmp ];
  propagatedBuildInputs = [
    ocaml gmp ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'sh'" "'-exc'" "'cc -c $CFLAGS -I/usr/local/include test.c'" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
