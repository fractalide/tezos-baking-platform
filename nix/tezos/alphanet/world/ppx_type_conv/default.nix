/*opam-version: "2.0"
  name: "ppx_type_conv"
  version: "v0.10.0"
  synopsis: "Support Library for type-driven code generators"
  description: "Part of the Jane Street's PPX rewriters
  collection."
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/ppx_type_conv"
  bug-reports: "https://github.com/janestreet/ppx_type_conv/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "ppx_core" {>= "v0.10" & < "v0.11"}
    "ppx_driver" {>= "v0.10" & < "v0.11"}
    "ppx_metaquot" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
    "ocaml-migrate-parsetree" {>= "0.4"}
    "ppx_derivers"
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/ppx_type_conv.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_type_conv-v0.10.0.tar.gz"
    checksum: [
      "md5=ae87662d39eebc6a2df6851c0f4da88c"
     
  "sha256=0976d79d20d50a40926f5a7a83de0420b6a5d33456c73667f9840deb56f37f3c"
     
  "sha512=af7a7458986c7fbf00d40d46f2481316cf652193d9e44ee98b16f434cdeaa00c81dbcf8782558dea78832ed2be5d389943de386fbf436ac87f5583ab53ef4de5"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, ppx_core, ppx_driver,
  ppx_metaquot, jbuilder, ocaml-migrate-parsetree, ppx_derivers, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.04.1") >= 0;
assert (vcompare ppx_core "v0.10") >= 0 && (vcompare ppx_core "v0.11") < 0;
assert (vcompare ppx_driver "v0.10") >= 0 && (vcompare ppx_driver "v0.11") <
  0;
assert (vcompare ppx_metaquot "v0.10") >= 0 && (vcompare ppx_metaquot
  "v0.11") < 0;
assert (vcompare jbuilder "1.0+beta12") >= 0;
assert (vcompare ocaml-migrate-parsetree "0.4") >= 0;

stdenv.mkDerivation rec {
  pname = "ppx_type_conv";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_type_conv-v0.10.0.tar.gz";
    sha256 = "0g3zydbfn3c4z5kkdisn6k9sbdi00kg86yjsdy9402nm42fxfxh9";
  };
  buildInputs = [
    ocaml ppx_core ppx_driver ppx_metaquot jbuilder ocaml-migrate-parsetree
    ppx_derivers findlib ];
  propagatedBuildInputs = [
    ocaml ppx_core ppx_driver ppx_metaquot jbuilder ocaml-migrate-parsetree
    ppx_derivers ];
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
