/*opam-version: "2.0"
  name: "ezjsonm"
  version: "0.6.0"
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
    ["jbuilder" "subst" "-p" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
  ]
  dev-repo: "git+https://github.com/mirage/ezjsonm.git"
  url {
    src:
     
  "https://github.com/mirage/ezjsonm/releases/download/0.6.0/ezjsonm-0.6.0.tbz"
    checksum: [
      "md5=97ed286b2a4937411779e895350df061"
     
  "sha256=716a2554a6c208cfed7878b1ce1d90030cf22ea40d896fccb2999670f5cfed6e"
     
  "sha512=33bc474c31b2db927dd5900d4ee332e107c42ba87f0c343716613c61c0b1862489a8dca7101489cd61482f8bb6e3a62b129b768921f328bd54574a1a2f0f23e7"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, jbuilder,
  alcotest ? null, jsonm, sexplib, hex }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare jbuilder "1.0+beta9") >= 0;
assert doCheck -> (vcompare alcotest "0.4.0") >= 0;
assert (vcompare jsonm "0.9.1") >= 0;

stdenv.mkDerivation rec {
  pname = "ezjsonm";
  version = "0.6.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/ezjsonm/releases/download/0.6.0/ezjsonm-0.6.0.tbz";
    sha256 = "0vpdrzsp15lrnb66z28dlhpg4303j0fwxcbqg3nwy262lra2aski";
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
