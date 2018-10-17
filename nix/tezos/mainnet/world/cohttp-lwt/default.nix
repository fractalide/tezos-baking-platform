/*opam-version: "2.0"
  name: "cohttp-lwt"
  version: "1.0.2"
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
    "cohttp" {>= "1.0.0"}
    "lwt"
  ]
  conflicts: [
    "lwt" {< "2.5.0"}
  ]
  build: [
    ["jbuilder" "subst" "-p" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git+https://github.com/mirage/ocaml-cohttp.git"
  url {
    src:
     
  "https://github.com/mirage/ocaml-cohttp/releases/download/v1.0.2/cohttp-1.0.2.tbz"
    checksum: [
      "md5=d0a46e32911773862e1a9b420c0058bc"
     
  "sha256=64a7249ef1568006108280343b416dd2b5807af603472246c24ecf43b1a207f5"
     
  "sha512=f8eb507358709002343ab7e5cf84afe8f5fdf76c0e47fadd7186e781d340b180df0d6162fc051e37a6a2d9ad379d9617d68c5dfc55031a8269f45e1a91f800cb"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, cohttp, lwt,
  findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.03.0") >= 0;
assert (vcompare jbuilder "1.0+beta10") >= 0;
assert (vcompare cohttp "1.0.0") >= 0;
assert !((vcompare lwt "2.5.0") < 0);

stdenv.mkDerivation rec {
  pname = "cohttp-lwt";
  version = "1.0.2";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v1.0.2/cohttp-1.0.2.tbz";
    sha256 = "1x87laql7ksfq9324iq3yrx81dfjdm0knd40h880d02ny6g299v4";
  };
  buildInputs = [
    ocaml jbuilder cohttp lwt findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder cohttp lwt ];
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
