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
    checksum: [
      "md5=6ba2e9690b1f579ba562b86022d1c308"
     
  "sha256=413e01444bdef2c4a231ddb1281b29bbc7b0c4bd780b7da47d9255b193bfcc56"
     
  "sha512=9adab758f2e68f155775559ed6568b1c3338d03291a27108b7e47a4fc5bbe65c6451c9bb90fc3270b62148213dfcc30b709b6a95e99d218884f915b48ecda9ff"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.06.0") >= 0 && (vcompare ocaml "4.08") < 0;
assert (vcompare findlib "1.5.0") >= 0;

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
