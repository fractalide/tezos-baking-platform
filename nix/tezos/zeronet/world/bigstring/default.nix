/*opam-version: "2.0"
  name: "bigstring"
  version: "0.2"
  synopsis: "Bigstring built on top of bigarrays, and convenient
  functions"
  description: """
  Bigstrings are useful for interfacing with C, low level IO,
  memory-mapping, etc."""
  maintainer: "Simon Cruanes <simon.cruanes.2007@m4x.org>"
  authors: "Simon Cruanes <simon.cruanes.2007@m4x.org>"
  tags: ["bigstring" "bigarray"]
  homepage: "https://github.com/c-cube/ocaml-bigstring/"
  bug-reports: "https://github.com/c-cube/ocaml-bigstring/issues"
  depends: [
    "ocaml" {>= "4.03.0"}
    "jbuilder" {build & >= "1.0+beta19.1"}
    "base-bigarray"
    "base-bytes"
  ]
  build: [
    ["jbuilder" "build" "-j" jobs "-p" name "@install"]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git://github.com/c-cube/ocaml-bigstring"
  url {
    src: "https://github.com/c-cube/ocaml-bigstring/archive/0.2.tar.gz"
    checksum: [
      "md5=5582e995b7d4c9e4a2949214756db7dd"
     
  "sha256=cee68d33b2644b8b98f98d4fd30d7e3915ed4ba639d35f42a7d75f64aa68f306"
     
  "sha512=cf44e85eb4df7485b23a7d456e8595b65e5d043f9d7d424e6bca285262d5137d80d5d4f88fbc65544761344fe6206fda7a85f447f31fbc4c463a33c9aff68573"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, base-bigarray,
  base-bytes, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.03.0") >= 0;
assert (vcompare jbuilder "1.0+beta19.1") >= 0;

stdenv.mkDerivation rec {
  pname = "bigstring";
  version = "0.2";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/c-cube/ocaml-bigstring/archive/0.2.tar.gz";
    sha256 = "01pkd2m68pyplx15zlrrlr5ys59rgq6x6kwdz6c8njv4n8rqvrnf";
  };
  buildInputs = [
    ocaml jbuilder base-bigarray base-bytes findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder base-bigarray base-bytes ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-j'" "1" "'-p'" pname "'@install'" ]
    (stdenv.lib.optionals doCheck [
      "'jbuilder'" "'runtest'" "'-p'" pname "'-j'" "1" ])
    ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
