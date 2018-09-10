/*opam-version: "2.0"
  name: "biniou"
  version: "1.2.0"
  synopsis:
    "Binary data format designed for speed, safety, ease of use and backward
  compatibility as protocols evolve"
  maintainer: "martin@mjambon.com"
  authors: "Martin Jambon"
  license: "BSD-3-Clause"
  homepage: "https://github.com/mjambon/biniou"
  bug-reports: "https://github.com/mjambon/biniou/issues"
  depends: [
    "ocaml" {>= "4.02.3"}
    "conf-which" {build}
    "jbuilder" {build & >= "1.0+beta7"}
    "easy-format"
  ]
  build: [
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name] {with-test}
  ]
  dev-repo: "git+https://github.com/mjambon/biniou.git"
  url {
    src: "https://github.com/mjambon/biniou/archive/v1.2.0.tar.gz"
    checksum: "md5=f3e92358e832ed94eaf23ce622ccc2f9"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, conf-which, jbuilder,
  easy-format, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.3";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta7";

stdenv.mkDerivation rec {
  pname = "biniou";
  version = "1.2.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mjambon/biniou/archive/v1.2.0.tar.gz";
    sha256 = "0dkx6m0vfyw04mss1495n8bjksvdjyvxaanjqcw1f830hvasjffr";
  };
  buildInputs = [
    ocaml conf-which jbuilder easy-format findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder easy-format ];
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
