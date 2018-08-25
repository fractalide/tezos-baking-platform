/*opam-version: "2.0"
  name: "uri"
  version: "1.9.7"
  synopsis: "An RFC3986 URI/URL parsing library"
  description: """
  This is an OCaml implementation of the
  [RFC3986](http://tools.ietf.org/html/rfc3986) specification 
  for parsing URI or URLs."""
  maintainer: "sheets@alum.mit.edu"
  authors: ["Anil Madhavapeddy" "David Sheets" "Rudi Grinberg"]
  license: "ISC"
  tags: ["url" "uri" "org:mirage" "org:xapi-project"]
  homepage: "https://github.com/mirage/ocaml-uri"
  bug-reports: "https://github.com/mirage/ocaml-uri/issues"
  depends: [
    "ocaml" {>= "4.03.0"}
    "jbuilder" {build & >= "1.0+beta7"}
    "ounit" {with-test & >= "1.0.2"}
    "ppx_sexp_conv" {>= "v0.9.0"}
    "re" {>= "1.7.2"}
    "sexplib" {>= "v0.9.0"}
    "stringext" {>= "1.4.0"}
  ]
  build: [
    ["jbuilder" "subst" "-p" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git+https://github.com/mirage/ocaml-uri.git"
  url {
    src:
     
  "https://github.com/mirage/ocaml-uri/releases/download/v1.9.7/uri-1.9.7.tbz"
    checksum: [
      "md5=2fb8da55f99a529bcb211a1d99822419"
     
  "sha256=a7ab6aa44232e03317b0db2ea200f422587bf801540755896ad30d17d8b682a8"
     
  "sha512=d63a5e382f5b101042ba3af58e16a09748f3a7fc37a675e33ef545e1bcd85e963b92f3a40d224465743fa2538b5bb7abc9234904df44c1edc084da417e1188e5"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, ounit ? null,
  ppx_sexp_conv, re, sexplib, stringext, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.03.0") >= 0;
assert (vcompare jbuilder "1.0+beta7") >= 0;
assert doCheck -> (vcompare ounit "1.0.2") >= 0;
assert (vcompare ppx_sexp_conv "v0.9.0") >= 0;
assert (vcompare re "1.7.2") >= 0;
assert (vcompare sexplib "v0.9.0") >= 0;
assert (vcompare stringext "1.4.0") >= 0;

stdenv.mkDerivation rec {
  pname = "uri";
  version = "1.9.7";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/ocaml-uri/releases/download/v1.9.7/uri-1.9.7.tbz";
    sha256 = "1a42nvc1f3fkda4ma1sl07w7nn12yh0a4bnvn0bk7q1j8aj6max7";
  };
  buildInputs = [
    ocaml jbuilder ounit ppx_sexp_conv re sexplib stringext findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder ounit ppx_sexp_conv re sexplib stringext ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] (stdenv.lib.optionals
    doCheck [ "'jbuilder'" "'runtest'" "'-p'" pname "'-j'" "1" ]) ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
