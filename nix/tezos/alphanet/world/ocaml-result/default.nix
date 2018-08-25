/*opam-version: "2.0"
  name: "result"
  version: "1.3"
  synopsis: "Compatibility Result module"
  description: """
  Projects that want to use the new result type defined in OCaml >= 4.03
  while staying compatible with older version of OCaml should use the
  Result module defined in this library."""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "BSD3"
  homepage: "https://github.com/janestreet/result"
  bug-reports: "https://github.com/janestreet/result/issues"
  depends: [
    "ocaml"
    "jbuilder" {build & >= "1.0+beta11"}
  ]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/result.git"
  url {
    src:
     
  "https://github.com/janestreet/result/releases/download/1.3/result-1.3.tbz"
    checksum: [
      "md5=4beebefd41f7f899b6eeba7414e7ae01"
     
  "sha256=53130eccf75860fbb0f84e8fc40236702e30dd0c17d782ae85eb01845b5f36d3"
     
  "sha512=a6c1a0dc754cb36cdf0ed92991e8a94797a74eb3d1ab1a93334a827b26bec276a3dce3a1048829c0a22e52456168250d4b76dcb7067e5c9aedbbfb56fdf43a11"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare jbuilder "1.0+beta11") >= 0;

stdenv.mkDerivation rec {
  pname = "result";
  version = "1.3";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/janestreet/result/releases/download/1.3/result-1.3.tbz";
    sha256 = "1lrnbxdq80gbhnp85mqp1kfk0bkh6q1c93sfz2qgnq2qyz60w4sk";
  };
  buildInputs = [
    ocaml jbuilder findlib ];
  propagatedBuildInputs = [
    ocaml jbuilder ];
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
