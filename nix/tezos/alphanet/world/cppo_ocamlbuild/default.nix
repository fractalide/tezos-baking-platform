/*opam-version: "2.0"
  name: "cppo_ocamlbuild"
  version: "1.6.0"
  synopsis: "ocamlbuild support for cppo, OCaml-friendly source
  preprocessor"
  maintainer: "martin@mjambon.com"
  authors: "Martin Jambon"
  license: "BSD-3-Clause"
  homepage: "http://mjambon.com/cppo.html"
  bug-reports: "https://github.com/mjambon/cppo/issues"
  depends: [
    "ocaml"
    "jbuilder" {build & >= "1.0+beta10"}
    "ocamlbuild"
    "cppo" {>= "1.6.0"}
  ]
  build: [
    ["jbuilder" "subst" "-p" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
  ]
  dev-repo: "git+https://github.com/mjambon/cppo.git"
  url {
    src: "https://github.com/mjambon/cppo/archive/v1.6.0.tar.gz"
    checksum: [
      "md5=aee411b3546bc5d198c71ae9185cade4"
     
  "sha256=29cb0223adc1f0c4c5238d6c7bf8931b909505aed349fde398fbf1a39eaa1819"
     
  "sha512=b10859ab908ca7a5b96a00ef69c2467d023be53ee5f7f29ee40ad99cf8c75828af2d1d946444916db5d8655449097d4e386a66b0196f6bc9f599ca9cb97a59cc"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, ocamlbuild, cppo,
  findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare jbuilder "1.0+beta10") >= 0;
assert (vcompare cppo "1.6.0") >= 0;

stdenv.mkDerivation rec {
  pname = "cppo_ocamlbuild";
  version = "1.6.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mjambon/cppo/archive/v1.6.0.tar.gz";
    sha256 = "068qmaga7wgvk3izsjfkmq2rb40vjgw7nv4d4g2w9w61mlih5jr9";
  };
  buildInputs = [
    ocaml jbuilder ocamlbuild cppo findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder ocamlbuild cppo ];
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
