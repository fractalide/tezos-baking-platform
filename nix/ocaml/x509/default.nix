/*opam-version: "2.0"
  name: "x509"
  version: "0.6.1"
  synopsis: "Public Key Infrastructure purely in OCaml"
  description: """
  X.509 is a public key infrastructure used mostly on the Internet.  It
  consists
  of certificates which include public keys and identifiers, signed by
  an
  authority.  Authorities must be exchanged over a second channel to
  establish the
  trust relationship.  This library implements most parts
  of
  [RFC5280](https://tools.ietf.org/html/rfc5280)
  and
  [RFC6125](https://tools.ietf.org/html/rfc6125).
  
  Read [further](https://nqsb.io) and our [Usenix Security 2015
  paper](https://usenix15.nqsb.io)."""
  maintainer: [
    "Hannes Mehnert <hannes@mehnert.org>" "David Kaloper
  <david@numm.org>"
  ]
  authors: [
    "David Kaloper <david@numm.org>" "Hannes Mehnert
  <hannes@mehnert.org>"
  ]
  license: "BSD2"
  tags: "org:mirage"
  homepage: "https://github.com/mirleft/ocaml-x509"
  doc: "https://mirleft.github.io/ocaml-x509/doc"
  bug-reports: "https://github.com/mirleft/ocaml-x509/issues"
  depends: [
    "ocaml" {>= "4.02.2"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "ppx_sexp_conv" {< "v0.11.0"}
    "topkg" {build}
    "result"
    "cstruct" {>= "1.6.0"}
    "sexplib"
    "asn1-combinators" {>= "0.2.0"}
    "ptime"
    "nocrypto" {>= "0.5.3"}
    "astring"
    "ounit" {with-test}
    "cstruct-unix" {with-test & >= "3.0.0"}
  ]
  build: [
    ["ocaml" "pkg/pkg.ml" "build" "--pinned" "%{pinned}%"]
    ["ocaml" "pkg/pkg.ml" "build" "--pinned" "%{pinned}%" "--tests" "true"]
      {with-test}
    ["ocaml" "pkg/pkg.ml" "test"] {with-test}
  ]
  dev-repo: "git+https://github.com/mirleft/ocaml-x509.git"
  url {
    src:
     
  "https://github.com/mirleft/ocaml-x509/releases/download/0.6.1/x509-0.6.1.tbz"
    checksum: "md5=a8cac9dca9bc4d39f7433403633d2223"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild,
  ppx_sexp_conv, topkg, result, cstruct, sexplib, asn1-combinators, ptime,
  nocrypto, astring, ounit ? null, cstruct-unix ? null }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.2";
assert stdenv.lib.versionOlder (stdenv.lib.getVersion ppx_sexp_conv)
  "v0.11.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion cstruct) "1.6.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion asn1-combinators)
  "0.2.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion nocrypto) "0.5.3";
assert doCheck -> stdenv.lib.versionAtLeast (stdenv.lib.getVersion
  cstruct-unix) "3.0.0";

stdenv.mkDerivation rec {
  pname = "x509";
  version = "0.6.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirleft/ocaml-x509/releases/download/0.6.1/x509-0.6.1.tbz";
    sha256 = "1c62mw9rnzq0rs3ihbhfs18nv4mdzwag7893hlqgji3wmaai70pk";
  };
  buildInputs = [
    ocaml findlib ocamlbuild ppx_sexp_conv topkg result cstruct sexplib
    asn1-combinators ptime nocrypto astring ]
  ++
  stdenv.lib.optional
  doCheck
  ounit
  ++
  [
    cstruct-unix ];
  propagatedBuildInputs = [
    ocaml ppx_sexp_conv result cstruct sexplib asn1-combinators ptime
    nocrypto astring ]
  ++
  stdenv.lib.optional
  doCheck
  ounit
  ++
  [
    cstruct-unix ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false" ]
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
