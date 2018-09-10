/*opam-version: "2.0"
  name: "base"
  version: "v0.10.0"
  synopsis: "Full standard library replacement for OCaml"
  description: """
  Full standard library replacement for OCaml
  
  Base is a complete and portable alternative to the OCaml standard
  library. It provides all standard functionalities one would expect
  from a language standard library. It uses consistent conventions
  across all of its module.
  
  Base aims to be usable in any context. As a result system dependent
  features such as I/O are not offered by Base. They are instead
  provided by companion libraries such as stdio:
  
    https://github.com/janestreet/stdio"""
  maintainer: "opensource@janestreet.com"
  authors: "Jane Street Group, LLC <opensource@janestreet.com>"
  license: "Apache-2.0"
  homepage: "https://github.com/janestreet/base"
  bug-reports: "https://github.com/janestreet/base/issues"
  depends: [
    "ocaml" {>= "4.04.1" & < "4.07.0"}
    "jbuilder" {build & >= "1.0+beta12"}
    "sexplib" {>= "v0.10" & < "v0.11"}
  ]
  depopts: ["base-native-int63"]
  build: ["jbuilder" "build" "-p" name "-j" jobs]
  dev-repo: "git+https://github.com/janestreet/base.git"
  url {
    src:
     
  "https://ocaml.janestreet.com/ocaml-core/v0.10/files/base-v0.10.0.tar.gz"
    checksum: [
      "md5=60a9db475c689720cc7fc4304e00b00e"
     
  "sha256=310976831b799888e5d6dbf58de78018515bb9a41003832733bd11de6e239e41"
     
  "sha512=417ed8777a1e529720507396a6bc3a40063313eb53b16455baf92347c0cd6d3a06286c9e3a0d4e5dadd06629ce27f744a23f13b93b4d8286237ddcb205282344"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, sexplib, findlib,
  base-native-int63 ? null }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.04.1") >= 0 && (vcompare ocaml "4.07.0") < 0;
assert (vcompare jbuilder "1.0+beta12") >= 0;
assert (vcompare sexplib "v0.10") >= 0 && (vcompare sexplib "v0.11") < 0;

stdenv.mkDerivation rec {
  pname = "base";
  version = "v0.10.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://ocaml.janestreet.com/ocaml-core/v0.10/files/base-v0.10.0.tar.gz";
    sha256 = "0hcy4dpdw4dx6ckq60qhljwmnl8qh3kqvxfvsvjqi63r3f1pc29i";
  };
  buildInputs = [
    ocaml jbuilder sexplib findlib ]
  ++
  stdenv.lib.optional
  (base-native-int63
  !=
  null)
  base-native-int63;
  propagatedBuildInputs = [
    ocaml jbuilder sexplib ]
  ++
  stdenv.lib.optional
  (base-native-int63
  !=
  null)
  base-native-int63;
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
