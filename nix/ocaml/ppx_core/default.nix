/*opam-version: "2.0"
  name: "ppx_core"
  version: "v0.10.0"
  synopsis: "Standard library for ppx rewriters"
  description: "Part of the Jane Street's PPX rewriters
  collection."
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/ppx_core"
  bug-reports: "https://github.com/janestreet/ppx_core/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "base" {>= "v0.10" & < "v0.11"}
    "ocaml-compiler-libs" {>= "v0.10" & < "v0.11"}
    "ppx_ast" {>= "v0.10" & < "v0.11"}
    "ppx_traverse_builtins" {>= "v0.10" & < "v0.11"}
    "stdio" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/ppx_core.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_core-v0.10.0.tar.gz"
    checksum: "md5=40c20d1696b703536e2503e5b5d0688a"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, base, ocaml-compiler-libs,
  ppx_ast, ppx_traverse_builtins, stdio, jbuilder, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.04.1";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion base) "v0.10" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion base) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml-compiler-libs)
  "v0.10" && stdenv.lib.versionOlder (stdenv.lib.getVersion
  ocaml-compiler-libs) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_ast) "v0.10" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion ppx_ast) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion
  ppx_traverse_builtins) "v0.10" && stdenv.lib.versionOlder
  (stdenv.lib.getVersion ppx_traverse_builtins) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion stdio) "v0.10" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion stdio) "v0.11";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta12";

stdenv.mkDerivation rec {
  pname = "ppx_core";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_core-v0.10.0.tar.gz";
    sha256 = "0g8dgz75xzf4azrsldf4lmahidw8dpjspi3vnkrd4s9pklz2f5nr";
  };
  buildInputs = [
    ocaml base ocaml-compiler-libs ppx_ast ppx_traverse_builtins stdio
    jbuilder findlib ];
  propagatedBuildInputs = [
    ocaml base ocaml-compiler-libs ppx_ast ppx_traverse_builtins stdio
    jbuilder ];
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
