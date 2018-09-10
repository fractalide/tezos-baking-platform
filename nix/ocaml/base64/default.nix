/*opam-version: "2.0"
  name: "base64"
  version: "2.2.0"
  synopsis: "Base64 encoding for OCaml"
  description: """
  Base64 is a group of similar binary-to-text encoding schemes that
  represent
  binary data in an ASCII string format by translating it into a
  radix-64
  representation.  It is specified in [RFC 4648][rfc4648].
  
  See also [documentation][docs].
  
  [rfc4648]: https://tools.ietf.org/html/rfc4648
  [docs]: http://mirage.github.io/ocaml-base64/base64/
  
  ## Example
  
  Simple encoding and decoding.
  
  ```shell
  utop # #require "base64";;
  utop # let enc = B64.encode "OCaml rocks!";;
  val enc : string = "T0NhbWwgcm9ja3Mh"
  utop # let plain = B64.decode enc;;
  val plain : string = "OCaml rocks!"
  ```
  
  ##
  License
  
  [ISC](https://www.isc.org/downloads/software-support-policy/isc-license/)"""
  maintainer: "mirageos-devel@lists.xenproject.org"
  authors: ["Thomas Gazagnaire" "Anil Madhavapeddy" "Peter Zotov"]
  license: "ISC"
  homepage: "https://github.com/mirage/ocaml-base64"
  doc: "http://mirage.github.io/ocaml-base64/"
  bug-reports: "https://github.com/mirage/ocaml-base64/issues"
  depends: [
    "ocaml"
    "base-bytes"
    "jbuilder" {build & >= "1.0+beta10"}
    "bos" {with-test}
    "rresult" {with-test}
    "alcotest" {with-test & >= "0.4.0"}
  ]
  build: [
    ["jbuilder" "subst"] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name] {with-test}
  ]
  dev-repo: "git+https://github.com/mirage/ocaml-base64.git"
  url {
    src:
     
  "https://github.com/mirage/ocaml-base64/releases/download/v2.2.0/base64-2.2.0.tbz"
    checksum: "md5=49f2bc4ae37b832c652277c0b701a02a"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, base-bytes, jbuilder,
  bos ? null, rresult ? null, alcotest ? null, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta10";
assert doCheck -> stdenv.lib.versionAtLeast (stdenv.lib.getVersion alcotest)
  "0.4.0";

stdenv.mkDerivation rec {
  pname = "base64";
  version = "2.2.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/ocaml-base64/releases/download/v2.2.0/base64-2.2.0.tbz";
    sha256 = "0ky91yjxkgf6zcpx39nvr96y4wz35pi1sdwaqr1z6bp2dacsvnbx";
  };
  buildInputs = [
    ocaml base-bytes jbuilder ]
  ++
  stdenv.lib.optional
  doCheck
  bos
  ++
  stdenv.lib.optional
  doCheck
  rresult
  ++
  [
    alcotest findlib ];
  propagatedBuildInputs = [
    ocaml base-bytes jbuilder ]
  ++
  stdenv.lib.optional
  doCheck
  bos
  ++
  stdenv.lib.optional
  doCheck
  rresult
  ++
  [
    alcotest ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] (stdenv.lib.optionals
    doCheck [ "'jbuilder'" "'runtest'" "'-p'" pname ]) ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
