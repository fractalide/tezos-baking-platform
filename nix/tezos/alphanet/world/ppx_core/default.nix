/*opam-version: "2.0"
  name: "ppx_core"
  version: "v0.10.0"
  synopsis: "Standard library for ppx rewriters"
  description: "Part of the Jane Street's PPX rewriters
  collection."
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/ppx_core"
  bug-reports: "https://github.com/janestreet/ppx_core/issues"
  depends: [
    "ocaml" {>= "4.04.1"}
    "base" {>= "v0.10" & < "v0.11"}
    "ocaml-compiler-libs" {>= "v0.10" & < "v0.11"}
    "ppx_ast" {>= "v0.10" & < "v0.11"}
    "ppx_traverse_builtins" {>= "v0.10" & < "v0.11"}
    "stdio" {>= "v0.10" & < "v0.11"}
    "jbuilder" {build & >= "1.0+beta12"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/ppx_core.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_core-v0.10.0.tar.gz"
    checksum: [
      "md5=40c20d1696b703536e2503e5b5d0688a"
     
  "sha256=d916273e9d3769d2f2b47bc4abe56d88b70855a5c435aaf357c4fd5ece7f0d3d"
     
  "sha512=af49081d3445b5e33b9fd346b6612980b28f687fba42987f14e7fadcb55a9de359f3bec48a0027ec9f96037b9bf2f6048298e16a6d05496ef9dcb3a6db052c81"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, base, ocaml-compiler-libs,
  ppx_ast, ppx_traverse_builtins, stdio, jbuilder, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.04.1") >= 0;
assert (vcompare base "v0.10") >= 0 && (vcompare base "v0.11") < 0;
assert (vcompare ocaml-compiler-libs "v0.10") >= 0 && (vcompare
  ocaml-compiler-libs "v0.11") < 0;
assert (vcompare ppx_ast "v0.10") >= 0 && (vcompare ppx_ast "v0.11") < 0;
assert (vcompare ppx_traverse_builtins "v0.10") >= 0 && (vcompare
  ppx_traverse_builtins "v0.11") < 0;
assert (vcompare stdio "v0.10") >= 0 && (vcompare stdio "v0.11") < 0;
assert (vcompare jbuilder "1.0+beta12") >= 0;

stdenv.mkDerivation rec {
  pname = "ppx_core";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/ppx_core-v0.10.0.tar.gz";
    sha256 = "0g8dgz75xzf4azrsldf4lmahidw8dpjspi3vnkrd4s9pklz2f5nr";
  };
  buildInputs = [
    ocaml base ocaml-compiler-libs ppx_ast ppx_traverse_builtins stdio
    jbuilder findlib ];
  propagatedBuildInputs = [
    ocaml base ocaml-compiler-libs ppx_ast ppx_traverse_builtins stdio
    jbuilder ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
