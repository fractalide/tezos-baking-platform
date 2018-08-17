/*opam-version: "2.0"
  name: "alcotest-lwt"
  version: "0.8.0"
  synopsis: "Alcotest is a lightweight and colourful test
  framework."
  description: """
  Alcotest exposes simple interface to perform unit tests. It exposes
  a simple `TESTABLE` module type, a `check` function to assert
  test
  predicates and a `run` function to perform a list of `unit -> unit`
  test callbacks.
  
  Alcotest provides a quiet and colorful output where only faulty runs
  are fully displayed at the end of the run (with the full logs ready
  to
  inspect), with a simple (yet expressive) query language to select the
  tests to run."""
  maintainer: "thomas@gazagnaire.org"
  authors: "Thomas Gazagnaire"
  license: "ISC"
  homepage: "https://github.com/mirage/alcotest/"
  doc: "https://mirage.github.io/alcotest/"
  bug-reports: "https://github.com/mirage/alcotest/issues/"
  depends: [
    "ocaml" {>= "4.02.3"}
    "jbuilder" {build & >= "1.0+beta10"}
    "alcotest" {>= "0.8.0"}
    "lwt"
    "logs"
  ]
  build: [
    ["jbuilder" "subst" "-n" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git+https://github.com/mirage/alcotest.git"
  url {
    src:
     
  "https://github.com/mirage/alcotest/releases/download/0.8.0/alcotest-0.8.0.tbz"
    checksum: "md5=771277ef1fe21b17920b5b44acf441b3"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, alcotest, lwt,
  logs, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.3";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta10";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion alcotest) "0.8.0";

stdenv.mkDerivation rec {
  pname = "alcotest-lwt";
  version = "0.8.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/alcotest/releases/download/0.8.0/alcotest-0.8.0.tbz";
    sha256 = "0lc04fa0rg16zycykkghq0q1vlbf3spcfv93xczh2vcmf0fdvfnw";
  };
  buildInputs = [
    ocaml jbuilder alcotest lwt logs findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder alcotest lwt logs ];
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
