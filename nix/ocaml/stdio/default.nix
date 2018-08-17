/*opam-version: "2.0"
  name: "stdio"
  version: "v0.10.0"
  synopsis: "Standard IO library for OCaml"
  description: """
  Stdio implements simple input/output functionalities for OCaml.
  
  It re-exports the input/output functions of the OCaml standard
  libraries using a more consistent API."""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/stdio"
  bug-reports: "https://github.com/janestreet/stdio/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "base" {>= "v0.10" & < "v0.11"}
    "sexplib" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/stdio.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/stdio-v0.10.0.tar.gz"
    checksum: "md5=11c9cb61b9e5feeae2bf5fc11d52b217"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, base, sexplib, jbuilder,
  findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.04.1";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion base) "v0.10" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion base) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion sexplib) "v0.10" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion sexplib) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta12";

stdenv.mkDerivation rec {
  pname = "stdio";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/stdio-v0.10.0.tar.gz";
    sha256 = "19vrww9zchx4lylibxqggsd6md8zkxrxfdp5jyf4rq1kffmpjnq4";
  };
  buildInputs = [
    ocaml base sexplib jbuilder findlib ];
  propagatedBuildInputs = [
    ocaml base sexplib jbuilder ];
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
