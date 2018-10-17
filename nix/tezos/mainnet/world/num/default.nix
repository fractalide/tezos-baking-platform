/*opam-version: "2.0"
  name: "num"
  version: "1.1"
  synopsis:
    "The legacy Num library for arbitrary-precision integer and rational
  arithmetic"
  maintainer: "Xavier Leroy <xavier.leroy@inria.fr>"
  authors: ["Valérie Ménissier-Morain" "Pierre Weis" "Xavier
  Leroy"]
  license: "LGPL 2.1 with OCaml linking exception"
  homepage: "https://github.com/ocaml/num/"
  bug-reports: "https://github.com/ocaml/num/issues"
  depends: [
    "ocaml" {>= "4.06.0"}
    "ocamlfind" {build & >= "1.7.3"}
  ]
  conflicts: ["base-num"]
  build: make
  install: [
    make
    "install" {!ocaml:preinstalled}
    "findlib-install" {ocaml:preinstalled}
  ]
  remove: [
    make
    "uninstall" {!ocaml:preinstalled}
    "findlib-uninstall" {ocaml:preinstalled}
  ]
  patches: ["findlib-install.patch" "installation-warning.patch"]
  dev-repo: "git+https://github.com/ocaml/num.git"
  extra-files: [
    ["installation-warning.patch" "md5=93c92bf6da6bae09d068da42b1bbaaac"]
    ["findlib-install.patch" "md5=3163a4c3f8dd084653eeb64d95311a2a"]
  ]
  url {
    src: "https://github.com/ocaml/num/archive/v1.1.tar.gz"
    checksum: [
      "md5=710cbe18b144955687a03ebab439ff2b"
     
  "sha256=04ac85f6465b9b2bf99e814ddc798a25bcadb3cca2667b74c1af02b6356893f6"
     
  "sha512=e7ee54e83eaab15ee879c5bb6deb0d76a3adf1ffd2cbd3f93cda63e7bc7b3a90313b94b4be078ecddaeee90a8a98a986d80c2fd6f1ad38faa35a318f77ec890e"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.06.0") >= 0;
assert (vcompare findlib "1.7.3") >= 0;

stdenv.mkDerivation rec {
  pname = "num";
  version = "1.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml/num/archive/v1.1.tar.gz";
    sha256 = "1xlkd0svc0mgq5s7nrm2rjrsvg15i9wxqkc1kvwjp6sv8vv8bb04";
  };
  postUnpack = "ln -sv ${./installation-warning.patch} \"$sourceRoot\"/installation-warning.patch\nln -sv ${./findlib-install.patch} \"$sourceRoot\"/findlib-install.patch";
  buildInputs = [
    ocaml findlib ];
  propagatedBuildInputs = [
    ocaml findlib ];
  configurePhase = "true";
  patches = [
    "findlib-install.patch" "installation-warning.patch" ];
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'findlib-install'" ] ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
