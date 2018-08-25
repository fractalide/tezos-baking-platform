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
let vcompare = stdenv.lib.versioning.debian.version.compare; in

stdenv.mkDerivation rec {
  pname = "mirage-no-xen";
  version = "1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = "/var/empty";
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
