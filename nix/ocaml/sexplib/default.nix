/*opam-version: "2.0"
  name: "sexplib"
  version: "v0.10.0"
  synopsis: "Library for serializing OCaml values to and from
  S-expressions"
  description: """
  Part of Jane Street's Core library
  The Core suite of libraries is an industrial strength alternative to
  OCaml's standard library that was developed by Jane Street, the
  largest industrial user of OCaml."""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/sexplib"
  bug-reports: "https://github.com/janestreet/sexplib/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "jbuilder" {build & >= "1.0+beta12"}
    "num"
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/sexplib.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/sexplib-v0.10.0.tar.gz"
    checksum: "md5=b8f5db21a2b19aadc753c6e626019068"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, num, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.04.1";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta12";

stdenv.mkDerivation rec {
  pname = "sexplib";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/sexplib-v0.10.0.tar.gz";
    sha256 = "0msc8dzlp6d7vnc0babgji3jjifri8nyyjxnalaapcpp8i67djwh";
  };
  buildInputs = [
    ocaml jbuilder num findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder num ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
