/*opam-version: "2.0"
  name: "irmin"
  version: "1.4.0"
  synopsis:
    "Irmin, a distributed database that follows the same design principles as
  Git"
  description: """
  Irmin is a library for persistent stores with built-in snapshot,
  branching and reverting mechanisms. It is designed to use a large
  variety of backends. Irmin is written in pure OCaml and does not
  depend on external C stubs; it aims to run everywhere, from Linux,
  to browsers and Xen unikernels."""
  maintainer: "thomas@gazagnaire.org"
  authors: ["Thomas Gazagnaire" "Thomas Leonard"]
  license: "ISC"
  homepage: "https://github.com/mirage/irmin"
  doc: "https://mirage.github.io/irmin/"
  bug-reports: "https://github.com/mirage/irmin/issues"
  depends: [
    "ocaml" {>= "4.03.0"}
    "jbuilder" {build & >= "1.0+beta10"}
    "result"
    "fmt" {>= "0.8.0"}
    "uri" {>= "1.3.12"}
    "cstruct" {>= "1.6.0"}
    "jsonm" {>= "1.0.0"}
    "lwt" {>= "2.4.7"}
    "ocamlgraph"
    "hex" {>= "0.2.0"}
    "logs" {>= "0.5.0"}
    "astring"
  ]
  build: [
    ["jbuilder" "subst"] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
  ]
  dev-repo: "git+https://github.com/mirage/irmin.git"
  url {
    src:
     
  "https://github.com/mirage/irmin/releases/download/1.4.0/irmin-1.4.0.tbz"
    checksum: "md5=e214dd3832bbe7b83df6c77263ac525b"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, result, fmt, uri,
  cstruct, jsonm, lwt, ocamlgraph, hex, logs, astring, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.03.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta10";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion fmt) "0.8.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion uri) "1.3.12";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion cstruct) "1.6.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jsonm) "1.0.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion lwt) "2.4.7";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion hex) "0.2.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion logs) "0.5.0";

stdenv.mkDerivation rec {
  pname = "irmin";
  version = "1.4.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/irmin/releases/download/1.4.0/irmin-1.4.0.tbz";
    sha256 = "019di4cz0z65knl232rnwj26npnc1mqh8j71xbf0mav6x350g1w5";
  };
  buildInputs = [
    ocaml jbuilder result fmt uri cstruct jsonm lwt ocamlgraph hex logs
    astring findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder result fmt uri cstruct jsonm lwt ocamlgraph hex logs
    astring ];
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
