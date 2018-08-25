/*opam-version: "2.0"
  name: "crowbar"
  version: "0.1"
  synopsis: "write tests, let a fuzzer find failing cases"
  description: """
  Crowbar is a library for testing code, combining
  QuickCheck-style
  property-based testing and the magical bug-finding powers
  of
  [afl-fuzz](http://lcamtuf.coredump.cx/afl/)."""
  maintainer: "stephen.dolan@cl.cam.ac.uk"
  authors: "Stephen Dolan"
  license: "MIT"
  homepage: "https://github.com/stedolan/crowbar"
  bug-reports: "https://github.com/stedolan/crowbar/issues"
  depends: [
    "ocaml" {>= "4.03"}
    "jbuilder" {build}
    "ocplib-endian"
    "cmdliner"
    "afl-persistent" {>= "1.1"}
    "calendar" {with-test}
    "xmldiff" {with-test}
    "fpath" {with-test}
    "uucp" {with-test}
    "uunf" {with-test}
    "uutf" {with-test}
  ]
  build: [
    [
      "jbuilder"
      "build"
      "--only-packages"
      name
      "--root"
      "."
      "-j"
      jobs
      "@install"
    ]
    [
      "jbuilder"
      "build"
      "--only-packages"
      name
      "--root"
      "."
      "-j"
      jobs
      "@runtest"
    ] {with-test}
  ]
  dev-repo: "git+https://github.com/stedolan/crowbar.git"
  url {
    src: "https://github.com/stedolan/crowbar/archive/v0.1.tar.gz"
    checksum: [
      "md5=cb7379d5182b56a18aba11aa40ed279a"
     
  "sha256=ef9d7ccdc2e0ed453af1a2e182763c7cac725760f9ad7e7ab8af459f98471a2e"
     
  "sha512=9f046a311a70166b7f8dcf75f95b90291fd0142f8bd1b5de48b446127e42de796431826fa769c5dacbf0fb64a3e7a0566537f2ead91618fe979f560d10f52b3c"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, ocplib-endian,
  cmdliner, afl-persistent, calendar ? null, xmldiff ? null, fpath ? null,
  uucp ? null, uunf ? null, uutf ? null, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.03") >= 0;
assert (vcompare afl-persistent "1.1") >= 0;

stdenv.mkDerivation rec {
  pname = "crowbar";
  version = "0.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/stedolan/crowbar/archive/v0.1.tar.gz";
    sha256 = "0bhs8yc9yidgp1x7xbgrc1bp5b3w7iv85qd2y4x4bvg0qb6pr7gg";
  };
  buildInputs = [
    ocaml jbuilder ocplib-endian cmdliner afl-persistent ]
  ++
  stdenv.lib.optional
  doCheck
  calendar
  ++
  stdenv.lib.optional
  doCheck
  xmldiff
  ++
  stdenv.lib.optional
  doCheck
  fpath
  ++
  stdenv.lib.optional
  doCheck
  uucp
  ++
  stdenv.lib.optional
  doCheck
  uunf
  ++
  stdenv.lib.optional
  doCheck
  uutf
  ++
  [
    findlib ];
  propagatedBuildInputs = [
    ocaml ocplib-endian cmdliner afl-persistent ]
  ++
  stdenv.lib.optional
  doCheck
  calendar
  ++
  stdenv.lib.optional
  doCheck
  xmldiff
  ++
  stdenv.lib.optional
  doCheck
  fpath
  ++
  stdenv.lib.optional
  doCheck
  uucp
  ++
  stdenv.lib.optional
  doCheck
  uunf
  ++
  stdenv.lib.optional
  doCheck
  uutf;
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'jbuilder'" "'build'" "'--only-packages'" pname "'--root'" "'.'"
      "'-j'" "1" "'@install'" ]
    (stdenv.lib.optionals doCheck [
      "'jbuilder'" "'build'" "'--only-packages'" pname "'--root'" "'.'"
      "'-j'" "1" "'@runtest'" ])
    ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
