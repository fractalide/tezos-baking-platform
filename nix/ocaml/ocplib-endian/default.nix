/*opam-version: "2.0"
  name: "ocplib-endian"
  version: "1.0"
  synopsis:
    "Optimised functions to read and write int16/32/64 from strings and
  bigarrays, based on new primitives added in version 4.01."
  description: """
  The library implements three modules:
  *
  [EndianString](https://github.com/OCamlPro/ocplib-endian/blob/master/src/endianString.cppo.mli)
  works directly on strings, and provides submodules BigEndian and
  LittleEndian, with their unsafe counter-parts;
  *
  [EndianBytes](https://github.com/OCamlPro/ocplib-endian/blob/master/src/endianBytes.cppo.mli)
  works directly on bytes, and provides submodules BigEndian and
  LittleEndian, with their unsafe counter-parts;
  *
  [EndianBigstring](https://github.com/OCamlPro/ocplib-endian/blob/master/src/endianBigstring.cppo.mli)
  works on bigstrings (Bigarrays of chars), and provides submodules BigEndian
  and LittleEndian, with their unsafe counter-parts;"""
  maintainer: "pierre.chambart@ocamlpro.com"
  authors: "Pierre Chambart"
  homepage: "https://github.com/OCamlPro/ocplib-endian"
  bug-reports: "https://github.com/OCamlPro/ocplib-endian/issues"
  depends: [
    "ocaml"
    "base-bytes"
    "ocamlfind"
    "cppo" {>= "1.1.0"}
    "ocamlbuild" {build}
  ]
  flags: light-uninstall
  build: [
    ["ocaml" "setup.ml" "-configure" "--disable-debug" "--prefix" prefix]
    ["ocaml" "setup.ml" "-build"]
  ]
  install: ["ocaml" "setup.ml" "-install"]
  remove: ["ocamlfind" "remove" "ocplib-endian"]
  dev-repo: "git+https://github.com/OCamlPro/ocplib-endian.git"
  url {
    src: "https://github.com/OCamlPro/ocplib-endian/archive/1.0.tar.gz"
    checksum: "md5=74b45ba33e189283170a748c2a3ed477"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, base-bytes, findlib, cppo,
  ocamlbuild }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion cppo) "1.1.0";

stdenv.mkDerivation rec {
  pname = "ocplib-endian";
  version = "1.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/OCamlPro/ocplib-endian/archive/1.0.tar.gz";
    sha256 = "0hwj09rnzjs0m0kazz5h2mgs6p95j0zlga8cda5srnzqmzhniwkn";
  };
  buildInputs = [
    ocaml base-bytes findlib cppo ocamlbuild ];
  propagatedBuildInputs = [
    ocaml base-bytes findlib cppo ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'setup.ml'" "'-configure'" "'--disable-debug'" "'--prefix'"
      "$out" ]
    [ "'ocaml'" "'setup.ml'" "'-build'" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'ocaml'" "'setup.ml'" "'-install'" ] ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
