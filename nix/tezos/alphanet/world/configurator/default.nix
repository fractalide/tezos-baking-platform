/*opam-version: "2.0"
  name: "configurator"
  version: "v0.10.0"
  synopsis: "Helper library for gathering system configuration"
  description: """
  Configurator is a small library that helps writing OCaml scripts that
  test features available on the system, in order to generate config.h
  files for instance.
  
  Configurator allows one to:
  - test if a C program compiles
  - query pkg-config
  - import #define from OCaml header files
  - generate config.h file"""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/configurator"
  bug-reports: "https://github.com/janestreet/configurator/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "base" {>= "v0.10" & < "v0.11"}
    "stdio" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/configurator.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/configurator-v0.10.0.tar.gz"
    checksum: [
      "md5=d02f66dd5dc4dbc3017f78c51209ba6b"
     
  "sha256=d8055de3d7d664f3864e21e798508810703a596238bd7b476296ffd13e9c7633"
     
  "sha512=ff41bef79487123e9c7bfc2cde84a12898e5f36ab8ed9b711c1f8925cd6b22d2f7759cf8e883b58d2886336e60f2bd4a3f78da3ff335dd17e02d0c93d920ae83"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, base, stdio, jbuilder,
  findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.04.1") >= 0;
assert (vcompare base "v0.10") >= 0 && (vcompare base "v0.11") < 0;
assert (vcompare stdio "v0.10") >= 0 && (vcompare stdio "v0.11") < 0;
assert (vcompare jbuilder "1.0+beta12") >= 0;

stdenv.mkDerivation rec {
  pname = "configurator";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/configurator-v0.10.0.tar.gz";
    sha256 = "0cvnkhzd3zwnc93ppg9qc9cklw0hi189irr19s3g6r6nszims1fq";
  };
  buildInputs = [
    ocaml base stdio jbuilder findlib ];
  propagatedBuildInputs = [
    ocaml base stdio jbuilder ];
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
