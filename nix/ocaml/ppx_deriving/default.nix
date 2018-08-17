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
      "sed" "-e" "s/%%{version}%%/%{version}%/g" "-e" "w pkg/META"
  "pkg/META.in"
    ]
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
  dev-repo: "git+https://github.com/whitequark/ppx_deriving.git"
  url {
    src: "https://github.com/ocaml-ppx/ppx_deriving/archive/v4.2.1.tar.gz"
    checksum: "md5=2195fccf2a527c3ff9ec5b4e36e2f0a8"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, ocamlbuild, findlib, cppo,
  cppo_ocamlbuild, ocaml-migrate-parsetree, ppx_derivers, ppx_tools, result,
  ounit ? null }:
assert stdenv.lib.versionOlder "4.03.0" (stdenv.lib.getVersion ocaml);
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion findlib) "1.6.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_tools) "4.02.3";

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
    ppx_derivers ppx_tools result ]
  ++
  stdenv.lib.optional
  doCheck
  ounit;
  propagatedBuildInputs = [
    ocaml findlib ocaml-migrate-parsetree ppx_derivers ppx_tools result ]
  ++
  stdenv.lib.optional
  doCheck
  ounit;
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'sed'" "'-e'" "'s/'%'{version}'%'/'${version}'/g'" "'-e'"
      "'w pkg/META'" "'pkg/META.in'" ]
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
