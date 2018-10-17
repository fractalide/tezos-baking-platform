/*opam-version: "2.0"
  name: "ppx_traverse_builtins"
  version: "v0.10.0"
  synopsis: "Builtins for Ppx_traverse"
  description: """
  This library defines the default methods for builtin types (int,
  string, list, ...) for Ppx_traverse."""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/ppx_traverse_builtins"
  bug-reports:
  "https://github.com/janestreet/ppx_traverse_builtins/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "jbuilder" {build & >= "1.0+beta12"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/ppx_traverse_builtins.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_traverse_builtins-v0.10.0.tar.gz"
    checksum: [
      "md5=9a9f9d79b64c6ad4d226d8246b41b261"
     
  "sha256=232607656cc97f3bbb165426a106ab2a916a1ece06c5b565ebbad6006a94e693"
     
  "sha512=fde9e6aaafa2d8181a415cf82c7c41b1d5c3742af3dcc79f4d112137154ffd2e2aceb3e90a076fbbbf6bddc40d69bd7a4873df087efcd1bca869c7123dc40f4b"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.04.1") >= 0;
assert (vcompare jbuilder "1.0+beta12") >= 0;

stdenv.mkDerivation rec {
  pname = "ppx_traverse_builtins";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_traverse_builtins-v0.10.0.tar.gz";
    sha256 = "14z6jim01mmsxdjvbi86rqg6m49amc3a29jl2sxknzy9dijhf9i3";
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
