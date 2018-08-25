/*opam-version: "2.0"
  name: "conduit-lwt"
  version: "1.1.0"
  synopsis: "An OCaml network connection establishment library"
  description: """
  [![Build
  Status](https://travis-ci.org/mirage/ocaml-conduit.svg?branch=master)](https://travis-ci.org/mirage/ocaml-conduit)
  
  The `conduit` library takes care of establishing and listening for 
  TCP and SSL/TLS connections for the Lwt and Async libraries.
  
  The reason this library exists is to provide a degree of abstraction
  from the precise SSL library used, since there are a variety of ways
  to bind to a library (e.g. the C FFI, or the Ctypes library), as well
  as well as which library is used (just OpenSSL for now).
  
  By default, OpenSSL is used as the preferred connection library, but
  you can force the use of the pure OCaml TLS stack by setting the
  environment variable `CONDUIT_TLS=native` when starting your program.
  
  The opam packages available are:
  
  - `conduit`: the main `Conduit` module
  - `conduit-lwt`: the portable Lwt implementation
  - `conduit-lwt-unix`: the Lwt/Unix implementation
  - `conduit-async` the Jane Street Async implementation
  - `mirage-conduit`: the MirageOS compatible implementation
  
  ### Debugging
  
  Some of the `Lwt_unix`-based modules use a non-empty
  `CONDUIT_DEBUG`
  environment variable to output debugging information to standard error.
  Just set this variable when running the program to see what URIs
  are being resolved to.
  
  ### Further Informartion
  
  * **API Docs:** http://docs.mirage.io/
  * **WWW:** https://github.com/mirage/ocaml-conduit
  * **E-mail:** <mirageos-devel@lists.xenproject.org>
  * **Bugs:** https://github.com/mirage/ocaml-conduit/issues"""
  maintainer: "anil@recoil.org"
  authors: [
    "Anil Madhavapeddy" "Thomas Leonard" "Thomas Gazagnaire" "Rudi
  Grinberg"
  ]
  license: "ISC"
  tags: "org:mirage"
  homepage: "https://github.com/mirage/ocaml-conduit"
  bug-reports: "https://github.com/mirage/ocaml-conduit/issues"
  depends: [
    "ocaml" {>= "4.03.0"}
    "base-unix"
    "jbuilder" {build & >= "1.0+beta9"}
    "ppx_sexp_conv"
    "conduit" {>= "1.1.0"}
    "lwt" {>= "3.0.0"}
  ]
  build: [
    ["jbuilder" "subst" "-p" name "--name" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
  ]
  dev-repo: "git+https://github.com/mirage/ocaml-conduit.git"
  url {
    src:
     
  "https://github.com/mirage/ocaml-conduit/releases/download/v1.1.0/conduit-1.1.0.tbz"
    checksum: [
      "md5=eb1d02c80d06ef812d97dc1ab588b597"
     
  "sha256=4ba5e96740342fba3605e0cc155bd1e2e559520b749e4a64e4fe6b03406f984b"
     
  "sha512=66cc7b2355bf726f79e55bfe5d0bbfe1ca8fa20c658879d4d9286a3edeb93e91e11d4eabed2cf2d615de2085385941d6e94f9a403024fa07df2fa8883f01e60f"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, base-unix, jbuilder,
  ppx_sexp_conv, conduit, lwt, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.03.0") >= 0;
assert (vcompare jbuilder "1.0+beta9") >= 0;
assert (vcompare conduit "1.1.0") >= 0;
assert (vcompare lwt "3.0.0") >= 0;

stdenv.mkDerivation rec {
  pname = "conduit-lwt";
  version = "1.1.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/ocaml-conduit/releases/download/v1.1.0/conduit-1.1.0.tbz";
    sha256 = "0jwqdx006szywij4m7kl1d95krg2s5dibk700lvblbrl81kyk9ab";
  };
  buildInputs = [
    ocaml base-unix jbuilder ppx_sexp_conv conduit lwt findlib ];
  propagatedBuildInputs = [
    ocaml base-unix jbuilder ppx_sexp_conv conduit lwt ];
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
