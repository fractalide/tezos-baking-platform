/*opam-version: "2.0"
  name: "calendar"
  version: "2.04"
  synopsis: "Library for handling dates and times in your program"
  maintainer: "https://github.com/ocaml/opam-repository/issues"
  authors: "Julien Signoles"
  license: "LGPL-2.1 with OCaml linking exception"
  homepage: "http://calendar.forge.ocamlcore.org/"
  bug-reports:
   
  "https://forge.ocamlcore.org/tracker/?atid=415&group_id=83&func=browse"
  depends: [
    "ocaml"
    "ocamlfind" {build}
  ]
  flags: light-uninstall
  build: [
    ["./configure"]
    [make]
  ]
  install: [make "install"]
  remove: ["ocamlfind" "remove" "calendar"]
  url {
    src:
      "http://forge.ocamlcore.org/frs/download.php/1481/calendar-2.04.tar.gz"
    checksum: "md5=625b4f32c9ff447501868fa1c44f4f4f"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:

stdenv.mkDerivation rec {
  pname = "calendar";
  version = "2.04";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://forge.ocamlcore.org/frs/download.php/1481/calendar-2.04.tar.gz";
    sha256 = "1xyrsh7x47qyhh5nyvj08wkjn3mrkrfb9ff2yfq5873s6fhgm9my";
  };
  buildInputs = [
    ocaml findlib ];
  propagatedBuildInputs = [
    ocaml ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'./configure'" ] [ "make" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'install'" ] ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
