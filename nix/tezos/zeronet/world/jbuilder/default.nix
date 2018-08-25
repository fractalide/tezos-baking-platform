/*opam-version: "2.0"
  name: "jbuilder"
  version: "transition"
  synopsis:
    "This is a transition package, jbuilder is now named dune. Use the
  dune"
  description: "package instead."
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "MIT"
  homepage: "https://github.com/ocaml/dune"
  bug-reports: "https://github.com/ocaml/dune/issues"
  depends: ["ocaml" "dune"]
  post-messages:
    "Jbuilder has been renamed and the jbuilder package is now a transition
  package. Use the dune package instead."
  dev-repo: "git+https://github.com/ocaml/dune.git"*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, dune, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in

stdenv.mkDerivation rec {
  pname = "jbuilder";
  version = "transition";
  name = "${pname}-${version}";
  inherit doCheck;
  src = "/var/empty";
  buildInputs = [
    ocaml dune findlib ];
  propagatedBuildInputs = [
    ocaml dune ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
