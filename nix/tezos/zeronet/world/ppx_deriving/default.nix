/*opam-version: "2.0"
  name: "ppx_deriving"
  version: "4.2.1"
  synopsis: "Type-driven code generation for OCaml >=4.02"
  description: """
  ppx_deriving provides common infrastructure for generating
  code based on type definitions, and a set of useful plugins
  for common tasks."""
  maintainer: "whitequark <whitequark@whitequark.org>"
  authors: "whitequark <whitequark@whitequark.org>"
  license: "MIT"
  tags: "syntax"
  homepage: "https://github.com/whitequark/ppx_deriving"
  doc: "https://whitequark.github.io/ppx_deriving"
  bug-reports: "https://github.com/whitequark/ppx_deriving/issues"
  depends: [
    "ocaml" {> "4.03.0"}
    "ocamlbuild" {build}
    "ocamlfind" {build & >= "1.6.0"}
    "cppo" {build}
    "cppo_ocamlbuild" {build}
    "ocaml-migrate-parsetree"
    "ppx_derivers"
    "ppx_tools" {>= "4.02.3"}
    "result"
    "ounit" {with-test}
  ]
  available: opam-version >= "1.2"
  build: [
    [
      "ocaml"
      "pkg/build.ml"
      "native=%{ocaml:native-dynlink}%"
      "native-dynlink=%{ocaml:native-dynlink}%"
    ]
    [
      "ocamlbuild"
      "-classic-display"
      "-use-ocamlfind"
      "src_test/test_ppx_deriving.byte"
      "--"
    ] {with-test}
    [make "doc"] {with-doc}
  ]
  substs: "pkg/META"
  dev-repo: "git+https://github.com/whitequark/ppx_deriving.git"
  url {
    src: "https://github.com/ocaml-ppx/ppx_deriving/archive/v4.2.1.tar.gz"
    checksum: [
      "md5=2195fccf2a527c3ff9ec5b4e36e2f0a8"
     
  "sha256=738f03e613641bb85f12e63ea382b427a79a2b63ffb29691d36006b77709319b"
     
  "sha512=306cd62a5a2906782789967c9df3efd0f9fc31c4f59e39d3f678a0a24a5c48a210af8a28c9483a0f6ae174a36f79a00a2b1a0d547006c84fcc7a91101c2cd41b"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, ocamlbuild, findlib, cppo,
  cppo_ocamlbuild, ocaml-migrate-parsetree, ppx_derivers, ppx_tools,
  ocaml-result, ounit ? null }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.03.0") > 0;
assert (vcompare findlib "1.6.0") >= 0;
assert (vcompare ppx_tools "4.02.3") >= 0;

stdenv.mkDerivation rec {
  pname = "ppx_deriving";
  version = "4.2.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml-ppx/ppx_deriving/archive/v4.2.1.tar.gz";
    sha256 = "16ri15vvf1k0sf8rdcpzccmrm9r7nj1a6gp629gvh6v42gk073vk";
  };
  buildInputs = [
    ocaml ocamlbuild findlib cppo cppo_ocamlbuild ocaml-migrate-parsetree
    ppx_derivers ppx_tools ocaml-result ]
  ++
  stdenv.lib.optional
  doCheck
  ounit;
  propagatedBuildInputs = [
    ocaml findlib ocaml-migrate-parsetree ppx_derivers ppx_tools ocaml-result ]
  ++
  stdenv.lib.optional
  doCheck
  ounit;
  configurePhase = "true";
  patches = [
    ./ppx_deriving.patch ];
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'pkg/build.ml'"
      "'native='${if !stdenv.isMips then "true" else "false"}" "'native-dynlink='${if
                                                                    !stdenv.isMips
                                                                    then
                                                                     
                                                                    "true"
                                                                    else
                                                                     
                                                                    "false"}" ] (stdenv.lib.optionals doCheck [ "'ocamlbuild'"
                                                                    "'-classic-display'"
                                                                    "'-use-ocamlfind'"
                                                                    "'src_test/test_ppx_deriving.byte'"
                                                                    "'--'" ]) [ "make"
                                                                    "'doc'" ] ];
      preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
      [ ];
      installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
      createFindlibDestdir = true;
    }
