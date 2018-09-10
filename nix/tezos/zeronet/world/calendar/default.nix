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
    checksum: [
      "md5=625b4f32c9ff447501868fa1c44f4f4f"
     
  "sha256=bea6faa0337a1c54b0f3c2b9b45c9eb90e2b2747406e6f0b841e1fd20fd4d9f7"
     
  "sha512=3941768428eda47f47912846cc2921ee82c722bda7cf6095c1c8bdcfebc19bb8f64ebb1a25475396d2a49c186b83421af63602a54a261684117b1c036a66cf3d"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in

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
