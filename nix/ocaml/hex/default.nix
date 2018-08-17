/*opam-version: "2.0"
  name: "hex"
  version: "1.2.0"
  synopsis: "Minimal library providing hexadecimal converters."
  description: """
  ```ocaml
  #require "hex";;
  # Hex.of_string "Hello world!";;
  - : Hex.t = "48656c6c6f20776f726c6421"
  # Hex.to_string "dead-beef";;
  - : string = "ޭ��"
  # Hex.hexdump (Hex.of_string "Hello world!\\n")
  00000000: 4865 6c6c 6f20 776f 726c 6421 0a        Hello world!.
  - : unit = ()
  ```"""
  maintainer: "thomas@gazagnaire.org"
  authors: ["Thomas Gazagnaire" "Trevor Summers Smith"]
  license: "ISC"
  homepage: "https://github.com/mirage/ocaml-hex"
  bug-reports: "https://github.com/mirage/ocaml-hex/issues"
  depends: [
    "ocaml"
    "jbuilder" {build & >= "1.0+beta8"}
    "cstruct" {>= "1.7.0"}
  ]
  build: [
    ["jbuilder" "subst"] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest"] {with-test}
  ]
  dev-repo: "git+https://github.com/mirage/ocaml-hex.git"
  url {
    src:
     
  "https://github.com/mirage/ocaml-hex/releases/download/v1.2.0/hex-1.2.0.tbz"
    checksum: "md5=c957b225be3df3725eaee8a3032bc359"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, cstruct, findlib
  }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta8";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion cstruct) "1.7.0";

stdenv.mkDerivation rec {
  pname = "hex";
  version = "1.2.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/ocaml-hex/releases/download/v1.2.0/hex-1.2.0.tbz";
    sha256 = "17hqf7z5afp2z2c55fk5myxkm7cm74259rqm94hcxkqlpdaqhm8h";
  };
  buildInputs = [
    ocaml jbuilder cstruct findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder cstruct ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] (stdenv.lib.optionals
    doCheck [ "'jbuilder'" "'runtest'" ]) ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
