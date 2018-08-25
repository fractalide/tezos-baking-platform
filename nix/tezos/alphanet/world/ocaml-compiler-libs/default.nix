/*opam-version: "2.0"
  name: "ocaml-compiler-libs"
  version: "v0.10.0"
  synopsis: "OCaml compiler libraries repackaged"
  description: """
  This packages exposes the OCaml compiler libraries repackages under
  the toplevel names Ocaml_common, Ocaml_bytecomp, ..."""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/ocaml-compiler-libs"
  bug-reports:
  "https://github.com/janestreet/ocaml-compiler-libs/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "jbuilder" {build & >= "1.0+beta12"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/ocaml-compiler-libs.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ocaml-compiler-libs-v0.10.0.tar.gz"
    checksum: [
      "md5=e94f23c3478cb42dc3472617ea86c800"
     
  "sha256=422d4e3f0e302935ddf868e7f6d5a431ee141043ba443ef0a081ef61ab506b1d"
     
  "sha512=8a672ce68d9ed3d62abc7853fb65af3494f3796f495467f72ac285cea83c706b7c982959bd2e134e80add719bdc4f374f72f0a44f669b5e05885160a3f9590fc"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.04.1") >= 0;
assert (vcompare jbuilder "1.0+beta12") >= 0;

stdenv.mkDerivation rec {
  pname = "ocaml-compiler-libs";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ocaml-compiler-libs-v0.10.0.tar.gz";
    sha256 = "07bba2mn3vw1l3q3wi5s8c819viilkazdrv8z3fkaa9h1qzlwba2";
  };
  buildInputs = [
    ocaml jbuilder findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder ];
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
