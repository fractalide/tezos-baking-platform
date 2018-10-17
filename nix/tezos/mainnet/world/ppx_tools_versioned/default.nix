/*opam-version: "2.0"
  name: "ppx_tools_versioned"
  version: "5.2"
  synopsis: "A variant of ppx_tools based on
  ocaml-migrate-parsetree"
  maintainer: "frederic.bour@lakaban.net"
  authors: [
    "Frédéric Bour <frederic.bour@lakaban.net>"
    "Alain Frisch <alain.frisch@lexifi.com>"
  ]
  license: "MIT"
  tags: "syntax"
  homepage: "https://github.com/let-def/ppx_tools_versioned"
  bug-reports:
  "https://github.com/let-def/ppx_tools_versioned/issues"
  depends: [
    "ocaml" {>= "4.02.0"}
    "jbuilder" {build & >= "1.0+beta17"}
    "ocaml-migrate-parsetree" {>= "0.5"}
  ]
  build: [
    ["jbuilder" "subst" "-p" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git://github.com/let-def/ppx_tools_versioned.git"
  url {
    src:
  "https://github.com/ocaml-ppx/ppx_tools_versioned/archive/5.2.tar.gz"
    checksum: [
      "md5=f2f1a1cd11aeb9f91a92ab691720a401"
     
  "sha256=e8a4b7adac8c7a86a8db427834b42a114922e988c89fe0cdb02b7ceeb146c0fd"
     
  "sha512=1efb7fc24f0b909d948aca53abee6e0613aaf101e6cf914772557ec00c879890d50b9c6e232f55a54381eab164a40d796d953b4992ef40a6e9141abd2b409cba"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder,
  ocaml-migrate-parsetree, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.0") >= 0;
assert (vcompare jbuilder "1.0+beta17") >= 0;
assert (vcompare ocaml-migrate-parsetree "0.5") >= 0;

stdenv.mkDerivation rec {
  pname = "ppx_tools_versioned";
  version = "5.2";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml-ppx/ppx_tools_versioned/archive/5.2.tar.gz";
    sha256 = "1zf08sqywz1bn36y17y8i3lj4j8i5as38y22vfl8cylcmjnvg978";
  };
  buildInputs = [
    ocaml jbuilder ocaml-migrate-parsetree findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder ocaml-migrate-parsetree ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] (stdenv.lib.optionals
    doCheck [ "'jbuilder'" "'runtest'" "'-p'" pname "'-j'" "1" ]) ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
