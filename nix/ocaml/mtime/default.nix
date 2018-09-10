/*opam-version: "2.0"
  name: "mtime"
  version: "1.1.0"
  synopsis: "Monotonic wall-clock time for OCaml"
  description: """
  Mtime has platform independent support for monotonic wall-clock time
  in pure OCaml. This time increases monotonically and is not subject
  to
  operating system calendar time adjustments. The library has types
  to
  represent nanosecond precision timestamps and time spans.
  
  The additional Mtime_clock library provide access to a system
  monotonic clock.
  
  Mtime has a no dependency. Mtime_clock depends on your system library.
  The optional JavaScript support depends on [js_of_ocaml][jsoo]. Mtime
  and its libraries are distributed under the ISC license.
  
  [jsoo]: http://ocsigen.org/js_of_ocaml/"""
  maintainer: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  authors: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  license: "ISC"
  tags: ["time" "monotonic" "system" "org:erratique"]
  homepage: "http://erratique.ch/software/mtime"
  doc: "http://erratique.ch/software/mtime"
  bug-reports: "https://github.com/dbuenzli/mtime/issues"
  depends: [
    "ocaml" {>= "4.03.0"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build}
  ]
  depopts: ["js_of_ocaml"]
  build: [
    "ocaml"
    "pkg/pkg.ml"
    "build"
    "--pinned"
    "%{pinned}%"
    "--with-js_of_ocaml"
    "%{js_of_ocaml:installed}%"
  ]
  dev-repo: "git+http://erratique.ch/repos/mtime.git"
  url {
    src: "http://erratique.ch/software/mtime/releases/mtime-1.1.0.tbz"
    checksum: "md5=2935fe4a36b721735f60c9c65ad63a26"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  js_of_ocaml ? null }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.03.0";

stdenv.mkDerivation rec {
  pname = "mtime";
  version = "1.1.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://erratique.ch/software/mtime/releases/mtime-1.1.0.tbz";
    sha256 = "1qb4ljwirrc3g8brh97s76rjky2cpmy7zm87y7iqd6pxix52ydk3";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg ]
  ++
  stdenv.lib.optional
  (js_of_ocaml
  !=
  null)
  js_of_ocaml;
  propagatedBuildInputs = [
    ocaml ]
  ++
  stdenv.lib.optional
  (js_of_ocaml
  !=
  null)
  js_of_ocaml;
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false"
      "'--with-js_of_ocaml'"
      "${if js_of_ocaml != null then "true" else "false"}" ] ];
    preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
    [ ];
    installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
    createFindlibDestdir = true;
  }
