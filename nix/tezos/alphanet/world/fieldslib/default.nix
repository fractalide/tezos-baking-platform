/*opam-version: "2.0"
  name: "fieldslib"
  version: "v0.10.0"
  synopsis:
    "Syntax extension to define first class values representing record
  fields, to get and set record fields, iterate and fold over all fields of a
  record and create new record values"
  description: """
  Part of Jane Street's Core library
  The Core suite of libraries is an industrial strength alternative to
  OCaml's standard library that was developed by Jane Street, the
  largest industrial user of OCaml."""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/fieldslib"
  bug-reports: "https://github.com/janestreet/fieldslib/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "base" {>= "v0.10" & < "v0.11"}
    "ppx_driver" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
    "ocaml-migrate-parsetree" {>= "0.4"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/fieldslib.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/fieldslib-v0.10.0.tar.gz"
    checksum: [
      "md5=c2cd9e061a0cee73b2909d1d56f3d8f3"
     
  "sha256=c1c509697128628fe4fa869148ad3f5572387ced6757767e398e060d4958867f"
     
  "sha512=76094087470fa7585e338f41689498d6e7e155910d92053fe96185c73937eaa4e3dde7d9ad0bff08cd6b810593a1b617b8ee8a17bb1452d1174a7c7d67ce7471"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, base, ppx_driver, jbuilder,
  ocaml-migrate-parsetree, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.04.1") >= 0;
assert (vcompare base "v0.10") >= 0 && (vcompare base "v0.11") < 0;
assert (vcompare ppx_driver "v0.10") >= 0 && (vcompare ppx_driver "v0.11") <
  0;
assert (vcompare jbuilder "1.0+beta12") >= 0;
assert (vcompare ocaml-migrate-parsetree "0.4") >= 0;

stdenv.mkDerivation rec {
  pname = "fieldslib";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/fieldslib-v0.10.0.tar.gz";
    sha256 = "0zw6b14hs1lf75z7cmv7xmy3hwjm7ynli4c6zbj8yqi8f5lhkif1";
  };
  buildInputs = [
    ocaml base ppx_driver jbuilder ocaml-migrate-parsetree findlib ];
  propagatedBuildInputs = [
    ocaml base ppx_driver jbuilder ocaml-migrate-parsetree ];
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
