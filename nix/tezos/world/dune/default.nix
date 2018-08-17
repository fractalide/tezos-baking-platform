/*opam-version: "2.0"
  name: "dune"
  version: "1.0.1"
  synopsis: "Fast, portable and opinionated build system"
  description: """
  dune is a build system that was designed to simplify the release of
  Jane Street packages. It reads metadata from "dune" files following a
  very simple s-expression syntax.
  
  dune is fast, it has very low-overhead and support parallel builds on
  all platforms. It has no system dependencies, all you need to build
  dune and packages using dune is OCaml. You don't need or make or bash
  as long as the packages themselves don't use bash explicitly.
  
  dune supports multi-package development by simply dropping
  multiple
  repositories into the same directory.
  
  It also supports multi-context builds, such as building against
  several opam roots/switches simultaneously. This helps maintaining
  packages across several versions of OCaml and gives cross-compilation
  for free."""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "MIT"
  homepage: "https://github.com/ocaml/dune"
  bug-reports: "https://github.com/ocaml/dune/issues"
  depends: [
    "ocaml" {>= "4.02.3"}
  ]
  conflicts: [
    "jbuilder" {!= "transition"}
  ]
  build: [
    ["ocaml" "configure.ml" "--libdir" lib]
    ["ocaml" "bootstrap.ml"]
    ["./boot.exe" "--release" "--subst"] {pinned}
    ["./boot.exe" "--release" "-j" jobs]
  ]
  dev-repo: "git+https://github.com/ocaml/dune.git"
  url {
    src:
  "https://github.com/ocaml/dune/releases/download/1.0.1/dune-1.0.1.tbz"
    checksum: [
      "md5=7f6c56aa5a9043afb7b0dd313887c7c9"
     
  "sha256=5a4f08c7d9a4ad97ebc561ab089e3e7bb2f1e6f8a0cfc4bf3aaeba11f286ae59"
     
  "sha512=f06c903a5607b4d5cce2e70d51d2e393ce91aa9d5880f677781e287d67ca43fef3acfbfc8b76b14969f9e0e2f38fa40f26507eb99357831828d0aeb49b12499f"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.3") >= 0;

stdenv.mkDerivation rec {
  pname = "dune";
  version = "1.0.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml/dune/releases/download/1.0.1/dune-1.0.1.tbz";
    sha256 = "0ndfhvr13fmf7azw9kx0z3kg3ckv7sg0iav1qpmrgbd4v73hhkss";
  };
  buildInputs = [
    ocaml findlib ];
  propagatedBuildInputs = [
    ocaml ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'ocaml'" "'configure.ml'" "'--libdir'" "$OCAMLFIND_DESTDIR" ] [
      "'ocaml'" "'bootstrap.ml'" ]
    [ "'./boot.exe'" "'--release'" "'-j'" "1" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
