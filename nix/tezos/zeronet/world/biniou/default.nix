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
    checksum: [
      "md5=f3e92358e832ed94eaf23ce622ccc2f9"
     
  "sha256=d939a9d58660201738c3d22ad5b7976deb2917b22591a07525807bb741357d36"
     
  "sha512=04c04c2dd5e3e1237106db257567ba6900bd94759b07b02ba2e0d9209d1bbdc9ed629864e06d44a8b61f72d46fbcc7a0ffc86f82feb223d9d99ca41afc625fab"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, conf-which, jbuilder,
  easy-format, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.3") >= 0;
assert (vcompare jbuilder "1.0+beta7") >= 0;

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
