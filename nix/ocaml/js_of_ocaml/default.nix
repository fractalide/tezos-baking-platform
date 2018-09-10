/*opam-version: "2.0"
  name: "js_of_ocaml"
  version: "3.1.0"
  synopsis: "Compiler from OCaml bytecode to Javascript"
  maintainer: "dev@ocsigen.org"
  authors: "Ocsigen team"
  homepage: "http://ocsigen.org/js_of_ocaml"
  bug-reports: "https://github.com/ocsigen/js_of_ocaml/issues"
  depends: [
    "ocaml" {>= "4.02.0"}
    "jbuilder" {build & >= "1.0+beta17"}
    "ocaml-migrate-parsetree"
    "ppx_tools_versioned"
    "uchar"
    "js_of_ocaml-compiler"
  ]
  conflicts: [
    "ppx_tools_versioned" {<= "5.0beta0"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/ocsigen/js_of_ocaml.git"
  url {
    src: "https://github.com/ocsigen/js_of_ocaml/archive/3.1.0.tar.gz"
    checksum: "md5=b7a03bea097ac6bda3aaaf4b12b82581"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder,
  ocaml-migrate-parsetree, ppx_tools_versioned, uchar, js_of_ocaml-compiler,
  findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta17";
assert !stdenv.lib.versionAtLeast "5.0beta0" (stdenv.lib.getVersion
  ppx_tools_versioned);

stdenv.mkDerivation rec {
  pname = "js_of_ocaml";
  version = "3.1.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocsigen/js_of_ocaml/archive/3.1.0.tar.gz";
    sha256 = "0f1xpj7qg9l5d6c2055yf4vmd0mc4xsybrfpm20lz06lh9ab2w3r";
  };
  buildInputs = [
    ocaml jbuilder ocaml-migrate-parsetree ppx_tools_versioned uchar
    js_of_ocaml-compiler findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder ocaml-migrate-parsetree ppx_tools_versioned uchar
    js_of_ocaml-compiler ];
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
