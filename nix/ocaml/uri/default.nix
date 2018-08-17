/*opam-version: "2.0"
  name: "uri"
  version: "1.9.6"
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
    "base-bytes"
    "jbuilder" {build & >= "1.0+beta7"}
    "ounit" {with-test & >= "1.0.2"}
    "ppx_sexp_conv" {>= "v0.9.0"}
    "re"
    "sexplib" {>= "v0.9.0"}
    "stringext" {>= "1.4.0"}
  ]
  build: [
    ["jbuilder" "subst"] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git+https://github.com/mirage/ocaml-uri.git"
  url {
    src:
     
  "https://github.com/mirage/ocaml-uri/releases/download/v1.9.6/uri-1.9.6.tbz"
    checksum: "md5=a6c4fbbe8e3fd84059fac7bd7bc7b3d2"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, base-bytes, jbuilder,
  ounit ? null, ppx_sexp_conv, re, sexplib, stringext, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.03.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta7";
assert doCheck -> stdenv.lib.versionAtLeast (stdenv.lib.getVersion ounit)
  "1.0.2";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_sexp_conv)
  "v0.9.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion sexplib) "v0.9.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion stringext) "1.4.0";

stdenv.mkDerivation rec {
  pname = "uri";
  version = "1.9.6";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/ocaml-uri/releases/download/v1.9.6/uri-1.9.6.tbz";
    sha256 = "1m845rwd70wi4iijkrigyz939m1x84ba70hvv0d9sgk6971w4kz0";
  };
  buildInputs = [
    ocaml base-bytes jbuilder ounit ppx_sexp_conv re sexplib stringext
    findlib ];
  propagatedBuildInputs = [
    ocaml base-bytes jbuilder ounit ppx_sexp_conv re sexplib stringext ];
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
