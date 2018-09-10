/*opam-version: "2.0"
  name: "ezjsonm"
  version: "0.5.0"
  synopsis: "An easy interface on top of the Jsonm library"
  description: """
  This version provides more convenient (but far less flexible)
  input and output functions that go to and from [string] values.
  This avoids the need to write signal code, which is useful for
  quick scripts that manipulate JSON.
  
  More advanced users should go straight to the Jsonm library and
  use it directly, rather than be saddled with the Ezjsonm
  interface."""
  maintainer: "thomas@gazagnaire.org"
  authors: "Thomas Gazagnaire"
  license: "ISC"
  tags: ["org:mirage" "org:ocamllabs"]
  homepage: "https://github.com/mirage/ezjsonm"
  doc: "https://mirage.github.io/ezjsonm"
  bug-reports: "https://github.com/mirage/ezjsonm/issues"
  depends: [
    "ocaml"
    "ocamlfind" {build}
    "jbuilder" {build & >= "1.0+beta9"}
    "alcotest" {with-test & >= "0.4.0"}
    "jsonm" {>= "0.9.1"}
    "sexplib"
    "hex"
  ]
  build: [
    ["jbuilder" "subst"] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
  ]
  dev-repo: "git+https://github.com/mirage/ezjsonm.git"
  url {
    src:
     
  "https://github.com/mirage/ezjsonm/releases/download/0.5.0/ezjsonm-0.5.0.tbz"
    checksum: "md5=3a081dee6fc0cc0ce9462986888fa0bf"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, jbuilder,
  alcotest ? null, jsonm, sexplib, hex }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta9";
assert doCheck -> stdenv.lib.versionAtLeast (stdenv.lib.getVersion alcotest)
  "0.4.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jsonm) "0.9.1";

stdenv.mkDerivation rec {
  pname = "ezjsonm";
  version = "0.5.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/ezjsonm/releases/download/0.5.0/ezjsonm-0.5.0.tbz";
    sha256 = "16ki5q250rv8yzqyixvygcdyncm2ijv94f7p5gjrjhias853pjhn";
  };
  buildInputs = [
    ocaml findlib jbuilder alcotest jsonm sexplib hex ];
  propagatedBuildInputs = [
    ocaml jbuilder alcotest jsonm sexplib hex ];
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
