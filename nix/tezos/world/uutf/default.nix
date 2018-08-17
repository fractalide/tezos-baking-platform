/*opam-version: "2.0"
  name: "uutf"
  version: "1.0.1"
  synopsis: "Non-blocking streaming Unicode codec for OCaml"
  description: """
  Uutf is a non-blocking streaming codec to decode and encode the
  UTF-8,
  UTF-16, UTF-16LE and UTF-16BE encoding schemes. It can efficiently
  work character by character without blocking on IO. Decoders
  perform
  character position tracking and support newline normalization.
  
  Functions are also provided to fold over the characters of UTF encoded
  OCaml string values and to directly encode characters in OCaml
  Buffer.t values.
  
  Uutf has no dependency and is distributed under the ISC
  license."""
  maintainer: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  authors: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  license: "ISC"
  tags: ["unicode" "text" "utf-8" "utf-16" "codec" "org:erratique"]
  homepage: "http://erratique.ch/software/uutf"
  doc: "http://erratique.ch/software/uutf/doc/Uutf"
  bug-reports: "https://github.com/dbuenzli/uutf/issues"
  depends: [
    "ocaml" {>= "4.01.0"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build}
    "uchar"
  ]
  depopts: ["cmdliner"]
  conflicts: [
    "cmdliner" {< "0.9.6"}
  ]
  build: [
    "ocaml"
    "pkg/pkg.ml"
    "build"
    "--pinned"
    "%{pinned}%"
    "--with-cmdliner"
    "%{cmdliner:installed}%"
  ]
  dev-repo: "git+http://erratique.ch/repos/uutf.git"
  url {
    src: "http://erratique.ch/software/uutf/releases/uutf-1.0.1.tbz"
    checksum: [
      "md5=b8535f974027357094c5cdb4bf03a21b"
     
  "sha256=123b26e7a471f2c5bd0fce454ccf515d299610ec356e321241fae0f75833e9be"
     
  "sha512=35cbee8c82a566f2fe4fcd549936d4c4dc67f5b71bfd3ea97ff25d7cf21cfb77cb5ee313c95ad26a2a61bb84aa48c300bbb79a1a7128c6161e9abe9c390a7d18"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  uchar, cmdliner ? null }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.01.0") >= 0;
assert !((vcompare cmdliner "0.9.6") < 0);

stdenv.mkDerivation rec {
  pname = "uutf";
  version = "1.0.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://erratique.ch/software/uutf/releases/uutf-1.0.1.tbz";
    sha256 = "1gp96dcggq7s84934vimxh89caaxa77lqiff1yywbwkilkkjcfqj";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg uchar ]
  ++
  stdenv.lib.optional
  (cmdliner
  !=
  null)
  cmdliner;
  propagatedBuildInputs = [
    ocaml uchar ]
  ++
  stdenv.lib.optional
  (cmdliner
  !=
  null)
  cmdliner;
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false"
      "'--with-cmdliner'" "${if cmdliner != null then "true" else "false"}" ] ];
    preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
    [ ];
    installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
    createFindlibDestdir = true;
  }
