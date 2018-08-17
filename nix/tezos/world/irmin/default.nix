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
    ["jbuilder" "subst" "-p" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
  ]
  dev-repo: "git+https://github.com/mirage/irmin.git"
  url {
    src:
     
  "https://github.com/mirage/irmin/releases/download/1.4.0/irmin-1.4.0.tbz"
    checksum: [
      "md5=e214dd3832bbe7b83df6c77263ac525b"
     
  "sha256=858707cae866ab0adceae14804710dcc5e6b84e4368b21a89dc57cf019892d05"
     
  "sha512=1e733e97318ab7ae0e0a64661f986166f4993fc4e650f290aae9738c0d39bf7e4e2baa88e07cd8181408c690909b2426313a007df63a705ef7cf04712f6cd885"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, result, fmt, uri,
  cstruct, jsonm, lwt, ocamlgraph, hex, logs, astring, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.03.0") >= 0;
assert (vcompare jbuilder "1.0+beta10") >= 0;
assert (vcompare fmt "0.8.0") >= 0;
assert (vcompare uri "1.3.12") >= 0;
assert (vcompare cstruct "1.6.0") >= 0;
assert (vcompare jsonm "1.0.0") >= 0;
assert (vcompare lwt "2.4.7") >= 0;
assert (vcompare hex "0.2.0") >= 0;
assert (vcompare logs "0.5.0") >= 0;

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
