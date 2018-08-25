/*opam-version: "2.0"
  name: "ppx_driver"
  version: "v0.10.4"
  synopsis: "Feature-full driver for OCaml AST transformers"
  description: "Part of the Jane Street's PPX rewriters
  collection."
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/ppx_driver"
  bug-reports: "https://github.com/janestreet/ppx_driver/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "ppx_core" {>= "v0.10" & < "v0.11"}
    "ppx_optcomp" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta18.1"}
    "ocaml-migrate-parsetree" {>= "1.0.9"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/ppx_driver.git"
  url {
    src: "https://github.com/janestreet/ppx_driver/archive/v0.10.4.tar.gz"
    checksum: [
      "md5=c4953d8c72ee88fa823293834f93a31f"
     
  "sha256=6695284572d0d2f36a8d0c9dd874d1509a02ade1039953ca7655ee4261622629"
     
  "sha512=87f2669b04bdbfb2349c469a6825872ed85b3f13f46e20bc1a6ada5eefbbbf8446a67d569c8d277b44304de1335a34d922f79cd095ebb5a83a7405e5ca28d379"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, ppx_core, ppx_optcomp,
  jbuilder, ocaml-migrate-parsetree, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.04.1") >= 0;
assert (vcompare ppx_core "v0.10") >= 0 && (vcompare ppx_core "v0.11") < 0;
assert (vcompare ppx_optcomp "v0.10") >= 0 && (vcompare ppx_optcomp "v0.11")
  < 0;
assert (vcompare jbuilder "1.0+beta18.1") >= 0;
assert (vcompare ocaml-migrate-parsetree "1.0.9") >= 0;

stdenv.mkDerivation rec {
  pname = "ppx_driver";
  version = "v0.10.4";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/janestreet/ppx_driver/archive/v0.10.4.tar.gz";
    sha256 = "0a96c9hl5vjmfv557683w6nh56jhs5sdi78cimmg7lnhf92ji5b6";
  };
  buildInputs = [
    ocaml ppx_core ppx_optcomp jbuilder ocaml-migrate-parsetree findlib ];
  propagatedBuildInputs = [
    ocaml ppx_core ppx_optcomp jbuilder ocaml-migrate-parsetree ];
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
