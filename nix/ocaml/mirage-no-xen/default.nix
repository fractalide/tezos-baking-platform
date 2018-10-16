/*opam-version: "2.0"
  name: "mirage-no-xen"
  version: "1"
  synopsis: "Virtual package conflicting with mirage-xen"
  maintainer: "mirageos-devel@lists.xenproject.org"
  authors: "mirageos-devel@lists.xenproject.org"
  license: "BSD2"
  homepage: "https://mirage.io"
  depends: ["ocaml"]
  conflicts: ["mirage-xen"]*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:

stdenv.mkDerivation rec {
  pname = "mirage-no-xen";
  version = "1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = (import <nixpkgs> {}).runCommand "empty" { outputHashMode = "recursive"; outputHashAlgo = "sha256"; outputHash = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5"; } "mkdir $out";
  buildInputs = [
    ocaml findlib ];
  propagatedBuildInputs = [
    ocaml ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
