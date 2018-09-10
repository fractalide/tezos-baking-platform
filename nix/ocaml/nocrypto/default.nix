/*opam-version: "2.0"
  name: "nocrypto"
  version: "0.5.4"
  synopsis: "Simpler crypto"
  description: """
  nocrypto is a small cryptographic library that puts emphasis on the
  applicative
  style and ease of use. It includes basic ciphers (AES, 3DES, RC4), hashes
  (MD5,
  SHA1, SHA2), public-key primitives (RSA, DSA, DH) and a strong RNG
  (Fortuna).
  
  RSA timing attacks are countered by blinding. AES timing attacks are
  avoided by
  delegating to AES-NI."""
  maintainer: "David Kaloper <david@numm.org>"
  authors: "David Kaloper <david@numm.org>"
  license: "ISC"
  tags: "org:mirage"
  homepage: "https://github.com/mirleft/ocaml-nocrypto"
  doc: "https://mirleft.github.io/ocaml-nocrypto/doc"
  bug-reports: "https://github.com/mirleft/ocaml-nocrypto/issues"
  depends: [
    "ocaml" {>= "4.02.0"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build}
    "cpuid" {build}
    "ocb-stubblr" {build}
    "ppx_deriving"
    "ppx_sexp_conv" {>= "113.33.01" & < "v0.11.0"}
    "ounit" {with-test}
    "cstruct" {>= "2.4.0"}
    "cstruct-lwt"
    "zarith"
    "lwt"
    "sexplib" {< "v0.11.0"}
    "mirage-no-xen"
    "mirage-no-solo5"
  ]
  conflicts: [
    "topkg" {< "0.9.1"}
    "ocb-stubblr" {< "0.1.0"}
    "mirage-xen" {< "2.2.0"}
    "sexplib" {= "v0.9.0"}
  ]
  build: [
    "ocaml"
    "pkg/pkg.ml"
    "build"
    "--pinned"
    "%{pinned}%"
    "--tests"
    "false"
    "--jobs"
    "1"
    "--with-lwt"
    "%{lwt:installed}%"
    "--xen"
    "false"
    "--freestanding"
    "false"
  ]
  dev-repo: "git+https://github.com/mirleft/ocaml-nocrypto.git"
  url {
    src:
     
  "https://github.com/mirleft/ocaml-nocrypto/releases/download/v0.5.4/nocrypto-0.5.4.tbz"
    checksum: "md5=c331a7a4d2a563d1d5ed581aeb849011"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  cpuid, ocb-stubblr, ppx_deriving, ppx_sexp_conv, ounit ? null, cstruct,
  cstruct-lwt, zarith, lwt, sexplib, mirage-no-xen, mirage-no-solo5 }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_sexp_conv)
  "113.33.01" && stdenv.lib.versionOlder (stdenv.lib.getVersion
  ppx_sexp_conv) "v0.11.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion cstruct) "2.4.0";
assert stdenv.lib.versionOlder (stdenv.lib.getVersion sexplib) "v0.11.0";
assert !stdenv.lib.versionOlder (stdenv.lib.getVersion topkg) "0.9.1";
assert !stdenv.lib.versionOlder (stdenv.lib.getVersion ocb-stubblr) "0.1.0";
assert stdenv.lib.getVersion sexplib != "v0.9.0";

stdenv.mkDerivation rec {
  pname = "nocrypto";
  version = "0.5.4";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirleft/ocaml-nocrypto/releases/download/v0.5.4/nocrypto-0.5.4.tbz";
    sha256 = "0zshi9hlhcz61n5z1k6fx6rsi0pl4xgahsyl2jp0crqkaf3hqwlg";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg cpuid ocb-stubblr ppx_deriving
    ppx_sexp_conv ]
  ++
  stdenv.lib.optional
  doCheck
  ounit
  ++
  [
    cstruct cstruct-lwt zarith lwt sexplib mirage-no-xen mirage-no-solo5 ];
  propagatedBuildInputs = [
    ocaml ppx_deriving ppx_sexp_conv ]
  ++
  stdenv.lib.optional
  doCheck
  ounit
  ++
  [
    cstruct cstruct-lwt zarith lwt sexplib mirage-no-xen mirage-no-solo5 ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false" "'--tests'"
      "'false'" "'--jobs'" "'1'" "'--with-lwt'"
      "${if lwt != null then "true" else "false"}" "'--xen'" "'false'" "'--freestanding'" "'false'" ]
      ];
    preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
    [ ];
    installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
    createFindlibDestdir = true;
  }
