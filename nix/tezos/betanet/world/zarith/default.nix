/*opam-version: "2.0"
  name: "zarith"
  version: "1.7"
  synopsis:
    "Implements arithmetic and logical operations over arbitrary-precision
  integers"
  description: """
  The Zarith library implements arithmetic and logical operations
  over
  arbitrary-precision integers. It uses GMP to efficiently
  implement
  arithmetic over big integers. Small integers are represented as Caml
  unboxed integers, for speed and space economy."""
  maintainer: "Xavier Leroy <xavier.leroy@inria.fr>"
  authors: ["Antoine Miné" "Xavier Leroy" "Pascal Cuoq"]
  homepage: "https://github.com/ocaml/Zarith"
  bug-reports: "https://github.com/ocaml/Zarith/issues"
  depends: [
    "ocaml"
    "ocamlfind"
    "conf-gmp"
    "conf-perl" {build}
  ]
  flags: light-uninstall
  build: [
    ["./configure"] {os != "openbsd" & os != "freebsd" & os != "macos"}
    [
      "sh"
      "-exc"
      "LDFLAGS=\"$LDFLAGS -L/usr/local/lib\" CFLAGS=\"$CFLAGS
  -I/usr/local/include\" ./configure"
    ] {os = "openbsd" | os = "freebsd"}
    [
      "sh"
      "-exc"
      "LDFLAGS=\"$LDFLAGS -L/opt/local/lib -L/usr/local/lib\"
  CFLAGS=\"$CFLAGS -I/opt/local/include -I/usr/local/include\" ./configure"
    ] {os = "macos"}
    [make]
  ]
  install: [make "install"]
  remove: ["ocamlfind" "remove" "zarith"]
  dev-repo: "git+https://github.com/ocaml/Zarith.git"
  url {
    src: "https://github.com/ocaml/Zarith/archive/release-1.7.tar.gz"
    checksum: [
      "md5=80944e2755ebb848451a77dc2ad0651b"
     
  "sha256=d641bb66d04461111b75f2fc37ad1eec764dcf326d98a51ac078695baea2ab3a"
     
  "sha512=812b5f9b24ce7a24d3370b8728ff6eeb56e3280fa1573e694fe54e781668c29bf8ff95e94aeff59df948adc85b8acd6b4efe117fb50a124f19b4227bee78e753"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, conf-gmp,
  conf-perl }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in

stdenv.mkDerivation rec {
  pname = "zarith";
  version = "1.7";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml/Zarith/archive/release-1.7.tar.gz";
    sha256 = "0fmblap5nsbqq0dab63d6b7lsxpc3snkgz7jfldi2qa4s1kbnhfn";
  };
  buildInputs = [
    ocaml findlib conf-gmp conf-perl ];
  propagatedBuildInputs = [
    ocaml findlib conf-gmp ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'./configure'" ] [ "make" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'install'" ] ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
