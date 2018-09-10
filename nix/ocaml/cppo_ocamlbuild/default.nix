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
    ["jbuilder" "subst"] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
  ]
  dev-repo: "git+https://github.com/mjambon/cppo.git"
  url {
    src: "https://github.com/mjambon/cppo/archive/v1.6.0.tar.gz"
    checksum: "md5=aee411b3546bc5d198c71ae9185cade4"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, ocamlbuild, cppo,
  findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta10";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion cppo) "1.6.0";

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
