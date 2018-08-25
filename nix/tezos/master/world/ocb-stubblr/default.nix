/*opam-version: "2.0"
  name: "ocb-stubblr"
  version: "0.1.1"
  synopsis: "OCamlbuild plugin for C stubs"
  description: """
  Do you get excited by C stubs? Do they sometimes make you swoon, and even
  faint,
  and in the end no `cmxa`s get properly linked -- not to mention
  correct
  multi-lib support?
  
  Do you wish that the things that excite you the most, would excite you just
  a
  little less? Then ocb-stubblr is just the library for you.
  
  ocb-stubblr is about ten lines of code that you need to repeat over, over,
  over
  and over again if you are using `ocamlbuild` to build OCaml projects
  that
  contain C stubs -- now with 100% more lib!
  
  It does what everyone wants to do with `.clib` files in their
  project
  directories. It can also clone the `.clib` and arrange for multiple
  compilations
  with different sets of discovered `cflags`.
  
  ocb-stubblr is distributed under the ISC license."""
  maintainer: "David Kaloper Meršinjak <david@numm.org>"
  authors: "David Kaloper Meršinjak <david@numm.org>"
  license: "ISC"
  tags: "ocamlbuild"
  homepage: "https://github.com/pqwy/ocb-stubblr"
  doc: "https://pqwy.github.io/ocb-stubblr/doc"
  bug-reports: "https://github.com/pqwy/ocb-stubblr/issues"
  depends: [
    "ocaml" {>= "4.01.0"}
    "ocamlfind" {build}
    "ocamlbuild" {>= "0.9.3" | < "0.9.0"}
    "topkg" {>= "0.8.1"}
    "astring"
  ]
  build: [
    "ocaml" "pkg/pkg.ml" "build" "--pinned" "%{pinned}%" "--tests"
  "false"
  ]
  dev-repo: "git+https://github.com/pqwy/ocb-stubblr.git"
  url {
    src:
     
  "https://github.com/pqwy/ocb-stubblr/releases/download/v0.1.1/ocb-stubblr-0.1.1.tbz"
    checksum: [
      "md5=607720dd18ca51e40645b42df5c1273e"
     
  "sha256=4e9c4fd031e008a65f14a0f3bf6914fa6632ab054aad8670dcb30621433feb98"
     
  "sha512=39b9a62af92b9e184373a55542ba5bedf8b975bb68b22aaed375bf95b77516dc3bdb6b94e0a9243bdcc94640bc96532714b94f463964491b97b8ce0fc3cd7044"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  astring }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.01.0") >= 0;
assert (vcompare ocamlbuild "0.9.3") >= 0 || (vcompare ocamlbuild "0.9.0") <
  0;
assert (vcompare topkg "0.8.1") >= 0;

stdenv.mkDerivation rec {
  pname = "ocb-stubblr";
  version = "0.1.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/pqwy/ocb-stubblr/releases/download/v0.1.1/ocb-stubblr-0.1.1.tbz";
    sha256 = "167b7x1j21mkviq8dbaa0nmk4rps2ilvzwx02igsc2706784z72f";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg astring ];
  propagatedBuildInputs = [
    ocaml ocamlbuild topkg astring ];
  configurePhase = "true";
  patches = [
    ./pkg-config.patch ];
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false" "'--tests'"
      "'false'" ]
    ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
