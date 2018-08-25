/*opam-version: "2.0"
  name: "js_of_ocaml"
  version: "3.2.0"
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
    src: "https://github.com/ocsigen/js_of_ocaml/archive/3.2.0.tar.gz"
    checksum: [
      "md5=5f7d6121f2b549b5ee83a625a142219b"
     
  "sha256=4c03c3051a3cba26bead759c02448ab2dd0c2df45972f7972754e7cbfdfc8647"
     
  "sha512=fd205be775b8df1b040c8d7eb733a35cd3bd96b3124d8a8665bfe77f408d5a2cdaaec855a1139281d75572300fdcb10a313f18ea5699c6d28f81519681745b71"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder,
  ocaml-migrate-parsetree, ppx_tools_versioned, uchar, js_of_ocaml-compiler,
  findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.0") >= 0;
assert (vcompare jbuilder "1.0+beta17") >= 0;
assert !((vcompare ppx_tools_versioned "5.0beta0") <= 0);

stdenv.mkDerivation rec {
  pname = "js_of_ocaml";
  version = "3.2.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocsigen/js_of_ocaml/archive/3.2.0.tar.gz";
    sha256 = "0iw6zkywprsl4ybzfwjryhnhrpdji920573mmnz2dfiw382w60sc";
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
