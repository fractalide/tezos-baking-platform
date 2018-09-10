/*opam-version: "2.0"
  name: "rresult"
  version: "0.5.0"
  synopsis: "Result value combinators for OCaml"
  description: """
  Rresult is an OCaml module for handling computation results and errors
  in an explicit and declarative manner, without resorting to
  exceptions. It defines combinators to operate on the `result` type
  available from OCaml 4.03 in the standard library.
  
  Rresult depends on the compatibility `result` package and is
  distributed under the ISC license."""
  maintainer: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  authors: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  license: "ISC"
  tags: ["result" "error" "declarative" "org:erratique"]
  homepage: "http://erratique.ch/software/rresult"
  doc: "http://erratique.ch/software/rresult"
  bug-reports: "https://github.com/dbuenzli/rresult/issues"
  depends: [
    "ocaml" {>= "4.01.0"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build}
    "result"
  ]
  build: ["ocaml" "pkg/pkg.ml" "build" "--pinned" "%{pinned}%"]
  dev-repo: "git+http://erratique.ch/repos/rresult.git"
  url {
    src: "http://erratique.ch/software/rresult/releases/rresult-0.5.0.tbz"
    checksum: "md5=2aa904e5f1707903da68d80d71c85637"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  result }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01.0";

stdenv.mkDerivation rec {
  pname = "rresult";
  version = "0.5.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://erratique.ch/software/rresult/releases/rresult-0.5.0.tbz";
    sha256 = "1xxycxhdhaq8p9vhwi93s2mlxjwgm44fcxybx5vghzgbankz9yhm";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg result ];
  propagatedBuildInputs = [
    ocaml result ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
