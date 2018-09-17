/*opam-version: "2.0"
  name: "cohttp"
  version: "1.1.0"
  synopsis: "An OCaml library for HTTP clients and servers"
  description: """
  [![Join the chat at
  https://gitter.im/mirage/ocaml-cohttp](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/mirage/ocaml-cohttp?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
  
  Cohttp is an OCaml library for creating HTTP daemons. It has a portable
  HTTP parser, and implementations using various asynchronous
  programming
  libraries:
  
  * `Cohttp_lwt_unix` uses the [Lwt](https://ocsigen.org/lwt/) library, and
    specifically the UNIX bindings.
  * `Cohttp_async` uses the
  [Async](https://realworldocaml.org/v1/en/html/concurrent-programming-with-async.html)
    library.
  * `Cohttp_lwt` exposes an OS-independent Lwt interface, which is used
    by the [Mirage](https://mirage.io/) interface to generate standalone
    microkernels (use the cohttp-mirage subpackage).
  * `Cohttp_lwt_xhr` compiles to a JavaScript module that maps the Cohttp
    calls to XMLHTTPRequests.  This is used to compile OCaml libraries like
    the GitHub bindings to JavaScript and still run efficiently.
  
  You can implement other targets using the parser very easily. Look at the
  `IO`
  signature in `lib/s.mli` and implement that in the desired backend.
  
  You can activate some runtime debugging by setting `COHTTP_DEBUG` to
  any
  value, and all requests and responses will be written to stderr. 
  Further
  debugging of the connection layer can be obtained by setting
  `CONDUIT_DEBUG`
  to any value."""
  maintainer: "anil@recoil.org"
  authors: [
    "Anil Madhavapeddy"
    "Stefano Zacchiroli"
    "David Sheets"
    "Thomas Gazagnaire"
    "David Scott"
    "Rudi Grinberg"
    "Andy Ray"
  ]
  license: "ISC"
  tags: ["org:mirage" "org:xapi-project"]
  homepage: "https://github.com/mirage/ocaml-cohttp"
  bug-reports: "https://github.com/mirage/ocaml-cohttp/issues"
  depends: [
    "ocaml" {>= "4.03.0"}
    "jbuilder" {build & >= "1.0+beta10"}
    "re" {>= "1.7.2"}
    "uri" {>= "1.9.0"}
    "fieldslib"
    "sexplib"
    "ppx_type_conv" {build & >= "v0.9.1"}
    "ppx_fields_conv" {>= "v0.9.0"}
    "ppx_sexp_conv" {>= "v0.9.0"}
    "stringext"
    "base64" {>= "2.0.0"}
    "fmt" {with-test}
    "jsonm" {build}
    "alcotest" {with-test}
  ]
  build: [
    ["jbuilder" "subst" "-p" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git+https://github.com/mirage/ocaml-cohttp.git"
  url {
    src:
     
  "https://github.com/mirage/ocaml-cohttp/releases/download/v1.1.0/cohttp-1.1.0.tbz"
    checksum: [
      "md5=7624e77774b90112370924f2d21af436"
     
  "sha256=b25482fa09312ee7408cea671f03d3c3d01580b6ab9a9e09a1d3d96331483ec4"
     
  "sha512=ebe39dd1c57ade842c2dbfcc6ce4cc72f891e8e17c1d9823c8351b315ecaefbba17b59a4763cde1e9a6ea14713e1f099df5ee990186a2ab7b362322e21803b3b"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, re, uri,
  fieldslib, sexplib, ppx_type_conv, ppx_fields_conv, ppx_sexp_conv,
  stringext, base64, fmt ? null, jsonm, alcotest ? null, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.03.0") >= 0;
assert (vcompare jbuilder "1.0+beta10") >= 0;
assert (vcompare re "1.7.2") >= 0;
assert (vcompare uri "1.9.0") >= 0;
assert (vcompare ppx_type_conv "v0.9.1") >= 0;
assert (vcompare ppx_fields_conv "v0.9.0") >= 0;
assert (vcompare ppx_sexp_conv "v0.9.0") >= 0;
assert (vcompare base64 "2.0.0") >= 0;

stdenv.mkDerivation rec {
  pname = "cohttp";
  version = "1.1.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v1.1.0/cohttp-1.1.0.tbz";
    sha256 = "1i1y90qn7nfkl44rx6mbns01bl63sc1iyrzaii0ffbii17x84m5j";
  };
  buildInputs = [
    ocaml jbuilder re uri fieldslib sexplib ppx_type_conv ppx_fields_conv
    ppx_sexp_conv stringext base64 ]
  ++
  stdenv.lib.optional
  doCheck
  fmt
  ++
  [
    jsonm ]
  ++
  stdenv.lib.optional
  doCheck
  alcotest
  ++
  [
    findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder re uri fieldslib sexplib ppx_type_conv ppx_fields_conv
    ppx_sexp_conv stringext base64 ]
  ++
  stdenv.lib.optional
  doCheck
  fmt
  ++
  stdenv.lib.optional
  doCheck
  alcotest;
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
