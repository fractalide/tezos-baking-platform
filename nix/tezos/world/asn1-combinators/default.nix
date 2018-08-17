/*opam-version: "2.0"
  name: "asn1-combinators"
  version: "0.2.0"
  synopsis: "Embed typed ASN.1 grammars in OCaml"
  description: """
  asn1-combinators is a library for expressing ASN.1 in OCaml. Skip the
  notation
  part of ASN.1, and embed the abstract syntax directly in the language.
  These
  abstract syntax representations can be used for parsing, serialization,
  or
  random testing.
  
  The only ASN.1 encodings currently supported are BER and
  DER.
  
  asn1-combinators is distributed under the ISC license."""
  maintainer: "David Kaloper Meršinjak <david@numm.org>"
  authors: "David Kaloper Meršinjak <david@numm.org>"
  license: "ISC"
  tags: "org:mirage"
  homepage: "https://github.com/mirleft/ocaml-asn1-combinators"
  doc: "https://mirleft.github.io/ocaml-asn1-combinators/doc"
  bug-reports:
  "https://github.com/mirleft/ocaml-asn1-combinators/issues"
  depends: [
    "ocaml" {>= "4.02.0"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build}
    "result"
    "cstruct"
    "zarith"
    "ptime"
    "ounit" {with-test}
  ]
  conflicts: [
    "cstruct" {< "1.6.0"}
  ]
  build: [
    ["ocaml" "pkg/pkg.ml" "build" "--pinned" "%{pinned}%" "--tests" "false"]
    ["ocaml" "pkg/pkg.ml" "build" "--pinned" "%{pinned}%" "--tests" "true"]
      {with-test}
    ["ocaml" "pkg/pkg.ml" "test"] {with-test}
  ]
  dev-repo: "git+https://github.com/mirleft/ocaml-asn1-combinators.git"
  url {
    src:
     
  "https://github.com/mirleft/ocaml-asn1-combinators/releases/download/v0.2.0/asn1-combinators-0.2.0.tbz"
    checksum: [
      "md5=f695aec35f8934d20d966032adbf3520"
     
  "sha256=109d7f0b494f98eaf393c68ece6c6ccc9f6ee31b3bab8b8d517dee3542cff3b1"
     
  "sha512=b46c6ccfa38b8ebb63c4e7ada70573b22b9099010ef1866758e3aab143db6267bbec9aa65efd3a887a5b1278d67467a0648b5b65ec3792f91ad7ee34f562c49d"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  result, cstruct, zarith, ptime, ounit ? null }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.0") >= 0;
assert !((vcompare cstruct "1.6.0") < 0);

stdenv.mkDerivation rec {
  pname = "asn1-combinators";
  version = "0.2.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirleft/ocaml-asn1-combinators/releases/download/v0.2.0/asn1-combinators-0.2.0.tbz";
    sha256 = "1cgkrx13bvkxa66qparv3ginx7ycdincx3n6jgrym62g945pz78h";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg result cstruct zarith ptime ]
  ++
  stdenv.lib.optional
  doCheck
  ounit;
  propagatedBuildInputs = [
    ocaml result cstruct zarith ptime ]
  ++
  stdenv.lib.optional
  doCheck
  ounit;
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false" "'--tests'"
      "'false'" ]
    (stdenv.lib.optionals doCheck [
      "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false" "'--tests'"
      "'true'" ])
    (stdenv.lib.optionals doCheck [ "'ocaml'" "'pkg/pkg.ml'" "'test'" ]) ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
