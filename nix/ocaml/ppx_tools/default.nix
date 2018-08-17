/*opam-version: "2.0"
  name: "ppx_tools"
  version: "5.1+4.06.0"
  synopsis: "Tools for authors of ppx rewriters and other syntactic
  tools"
  maintainer: "alain.frisch@lexifi.com"
  authors: "Alain Frisch <alain.frisch@lexifi.com>"
  license: "MIT"
  tags: "syntax"
  homepage: "https://github.com/ocaml-ppx/ppx_tools"
  bug-reports: "https://github.com/ocaml-ppx/ppx_tools/issues"
  depends: [
    "ocaml" {>= "4.06.0" & < "4.08"}
    "ocamlfind" {>= "1.5.0"}
  ]
  flags: light-uninstall
  build: [make "all"]
  install: [make "install"]
  remove: ["ocamlfind" "remove" "ppx_tools"]
  dev-repo: "git://github.com/ocaml-ppx/ppx_tools.git"
  url {
    src: "https://github.com/ocaml-ppx/ppx_tools/archive/5.1+4.06.0.tar.gz"
    checksum: "md5=6ba2e9690b1f579ba562b86022d1c308"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.06.0" &&
  stdenv.lib.versionOlder (stdenv.lib.getVersion ocaml) "4.08";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion findlib) "1.5.0";

stdenv.mkDerivation rec {
  pname = "ppx_tools";
  version = "5.1+4.06.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml-ppx/ppx_tools/archive/5.1+4.06.0.tar.gz";
    sha256 = "0mncpy9v2mcjgnj7s2vqpp2b1ixv54djicfx66ic9wny9d202gj1";
  };
  buildInputs = [
    ocaml findlib ];
  propagatedBuildInputs = [
    ocaml findlib ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'all'" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'install'" ] ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
