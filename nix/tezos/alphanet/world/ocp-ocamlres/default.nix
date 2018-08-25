/*opam-version: "2.0"
  name: "ocp-ocamlres"
  version: "0.4"
  synopsis: "Manipulation, injection and extraction of embedded
  resources"
  description: """
  A tool ocp-ocamlres to embed files and directories inside OCaml
  executables, with a companion library ocplib-ocamlres to manipulate
  them at run-time."""
  maintainer: "benjamin@ocamlpro.com"
  authors: "benjamin@ocamlpro.com"
  license: "GNU Lesser General Public License version 3"
  homepage: "https://github.com/OCamlPro/ocp-ocamlres"
  bug-reports: "https://github.com/OCamlPro/ocp-ocamlres/issues"
  depends: [
    "ocaml" {>= "4.02.0"}
    "ocamlfind"
    "base-unix"
    "pprint"
    "astring"
  ]
  build: [
    [make "all"]
    [make "doc"]
  ]
  install: [
    [make "BINDIR=%{bin}%" "LIBDIR=%{lib}%" "install"]
    [make "DOCDIR=%{doc}%" "install-doc"]
  ]
  remove: [
    [make "BINDIR=%{bin}%" "LIBDIR=%{lib}%" "uninstall"]
    [make "DOCDIR=%{doc}%" "uninstall-doc"]
  ]
  dev-repo: "git://github.com/OCamlPro/ocp-ocamlres"
  url {
    src: "https://github.com/OCamlPro/ocp-ocamlres/archive/v0.4.tar.gz"
    checksum: [
      "md5=725eb557e659c6febf8dc3044b323bd8"
     
  "sha256=658c2990e027e1e43a16290fd431f08c96b8630d91ac2b98003a9bc027179679"
     
  "sha512=b0b86b4abdc1fd447a880ed1a79e89169bf3e8731dd17c9031b8b11910af613ff8faa36380554a4eb8d408e79b0c972fa38a8d850b5662f6b670767908b34cd5"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, base-unix, pprint,
  astring }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.0") >= 0;

stdenv.mkDerivation rec {
  pname = "ocp-ocamlres";
  version = "0.4";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/OCamlPro/ocp-ocamlres/archive/v0.4.tar.gz";
    sha256 = "0ycn2wkw16rs02c2pb4i1mivi5lcy0qx83r92qxf9q97w282k335";
  };
  buildInputs = [
    ocaml findlib base-unix pprint astring ];
  propagatedBuildInputs = [
    ocaml findlib base-unix pprint astring ];
  configurePhase = "true";
  patches = [
    ./ocp-ocamlres.patch ];
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'all'" ] [ "make" "'doc'" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "make" "'BINDIR='$out/bin" "'LIBDIR='$OCAMLFIND_DESTDIR" "'install'" ]
    [ "make" "'DOCDIR='$out/share/doc" "'install-doc'" ] ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
