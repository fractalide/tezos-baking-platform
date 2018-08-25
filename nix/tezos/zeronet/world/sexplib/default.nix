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
    checksum: [
      "md5=b8f5db21a2b19aadc753c6e626019068"
     
  "sha256=90cb764c44f7b2ab1455b64bef2d8ad9452947946fa90598dda7994b7f434c57"
     
  "sha512=34186749437f8463e88dfefe53a4e453ba5fcb1d1db0e3f68312961e549ac853f42527d36c3366bf89afdd3a8558fa50ade5667a2aee159c589787ffa2967e19"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, num, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.04.1") >= 0;
assert (vcompare jbuilder "1.0+beta12") >= 0;

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
