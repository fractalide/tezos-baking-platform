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
    checksum: "md5=725eb557e659c6febf8dc3044b323bd8"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, base-unix, pprint,
  astring }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.0";

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
