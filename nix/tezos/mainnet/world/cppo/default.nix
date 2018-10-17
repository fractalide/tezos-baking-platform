/*opam-version: "2.0"
  name: "cppo"
  version: "1.6.4"
  synopsis: "Equivalent of the C preprocessor for OCaml programs"
  maintainer: "martin@mjambon.com"
  authors: "Martin Jambon"
  license: "BSD-3-Clause"
  homepage: "https://github.com/mjambon/cppo"
  bug-reports: "https://github.com/mjambon/cppo/issues"
  depends: [
    "ocaml"
    "jbuilder" {build & >= "1.0+beta17"}
    "base-bytes"
    "base-unix"
  ]
  build: [
    ["jbuilder" "subst" "-p" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name] {with-test}
  ]
  dev-repo: "git+https://github.com/mjambon/cppo.git"
  url {
    src: "https://github.com/mjambon/cppo/archive/v1.6.4.tar.gz"
    checksum: [
      "md5=f7a4a6a0e83b76562b45db3a93ffd204"
     
  "sha256=470a5225a5d3b06ced29581250562ef84b7a8bc6b9a632c96443391a443bab49"
     
  "sha512=89c6df66d597d929be7532ad82f0206b028bdbd79a0b4b39451bce3fa5bd63a80dce931d575f69bd7066de829347498c736657dfe9610b20700a652b9b542a4d"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, base-bytes,
  base-unix, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare jbuilder "1.0+beta17") >= 0;

stdenv.mkDerivation rec {
  pname = "cppo";
  version = "1.6.4";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mjambon/cppo/archive/v1.6.4.tar.gz";
    sha256 = "0jdb7d21lfa3ck4k59mrqs5pljzq5rb504jq57nnrc6klljm42j7";
  };
  buildInputs = [
    ocaml jbuilder base-bytes base-unix findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder base-bytes base-unix ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] (stdenv.lib.optionals
    doCheck [ "'jbuilder'" "'runtest'" "'-p'" pname ]) ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
