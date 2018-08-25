/*opam-version: "2.0"
  name: "ocp-build"
  version: "1.99.20-beta"
  synopsis: "Project builder for OCaml"
  description: """
  ocp-build main features are:
  * simple library/program description
  * detection of ocamlfind libraries (parsing of META)
  * incremental and parallel compilation of OCaml projects"""
  maintainer: "Fabrice Le Fessant <fabrice.le_fessant@ocamlpro.com>"
  authors: "Fabrice Le Fessant <fabrice.le_fessant@ocamlpro.com>"
  homepage: "http://www.typerex.org/ocp-build.html"
  bug-reports: "https://github.com/OCamlPro/ocp-build/issues"
  depends: [
    "ocaml" {>= "4.02.1"}
    "ocamlfind"
    "cmdliner" {>= "1.0"}
  ]
  conflicts: [
    "typerex" {< "1.99.7"}
    "typerex-build"
  ]
  build: [
    ["./configure" "--prefix" "%{prefix}%"]
    [make]
  ]
  install: [make "install"]
  remove: [
    ["rm" "-f" "%{prefix}%/bin/ocp-build"]
    ["rm" "-f" "%{prefix}%/bin/ocp-pp"]
    ["rm" "-rf" "%{prefix}%/lib/ocaml/typerex/ocp-build"]
    ["rm" "-rf" "%{prefix}%/lib/ocaml/typerex/ocplib-compat"]
    ["rm" "-rf" "%{prefix}%/lib/ocaml/typerex/ocplib-debug"]
    ["rm" "-rf" "%{prefix}%/lib/ocaml/typerex/ocplib-lang"]
    ["rm" "-rf" "%{prefix}%/lib/ocaml/typerex/ocplib-subcmd"]
    ["rm" "-rf" "%{prefix}%/lib/ocaml/typerex/ocplib-system"]
    ["rm" "-rf" "%{prefix}%/lib/ocaml/typerex/ocplib-unix"]
    ["rm" "-rf" "%{prefix}%/lib/ocaml/typerex/installed.ocp"]
    ["rm" "-rf" "%{prefix}%/lib/ocaml/site-ocp2/ocp-build"]
    ["sh" "-exc" "rmdir %{prefix}%/lib/ocaml/typerex || true"]
  ]
  dev-repo: "git+https://github.com/OCamlPro/ocp-build.git"
  url {
    src: "http://github.com/OCamlPro/ocp-build/archive/1.99.20-beta.tar.gz"
    checksum: [
      "md5=72d9c1b1a42d1873628e2d6e7529d8cb"
     
  "sha256=bf1b4e691eda1866ce787df1c573e8c0b8f65bc1bb696929a3d0fac2a23743c0"
     
  "sha512=4fcc31ef31661782d274158ac0f7996195dd4746d8cf089a7130ce315237a4c0a70eed3ed92eccbdb5a04571f871af0dc9cf1a98df75de207e1e98769fdf50bd"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, cmdliner }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.1") >= 0;
assert (vcompare cmdliner "1.0") >= 0;

stdenv.mkDerivation rec {
  pname = "ocp-build";
  version = "1.99.20-beta";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://github.com/OCamlPro/ocp-build/archive/1.99.20-beta.tar.gz";
    sha256 = "1h236yic5ynhlclnjsdvq5dzdf60x1rwbwbxg376c66s3rllw6xz";
  };
  buildInputs = [
    ocaml findlib cmdliner ];
  propagatedBuildInputs = [
    ocaml findlib cmdliner ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'./configure'" "'--prefix'" "$out" ] [ "make" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'install'" ] ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
