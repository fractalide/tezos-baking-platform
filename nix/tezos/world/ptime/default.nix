/*opam-version: "2.0"
  name: "ptime"
  version: "0.8.3"
  synopsis: "POSIX time for OCaml"
  description: """
  Ptime has platform independent POSIX time support in pure OCaml. It
  provides a type to represent a well-defined range of POSIX timestamps
  with picosecond precision, conversion with date-time values,
  conversion with [RFC 3339 timestamps][rfc3339] and pretty printing to
  a
  human-readable, locale-independent representation.
  
  The additional Ptime_clock library provides access to a system POSIX
  clock and to the system's current time zone offset.
  
  Ptime is not a calendar library.
  
  Ptime depends on the `result` compatibility package. Ptime_clock
  depends on your system library. Ptime_clock's optional JavaScript
  support depends on [js_of_ocaml][jsoo]. Ptime and its libraries
  are
  distributed under the ISC license.
  
  [rfc3339]: http://tools.ietf.org/html/rfc3339
  [jsoo]: http://ocsigen.org/js_of_ocaml/"""
  maintainer: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  authors: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  license: "ISC"
  tags: ["time" "posix" "system" "org:erratique"]
  homepage: "http://erratique.ch/software/ptime"
  doc: "http://erratique.ch/software/ptime/doc"
  bug-reports: "https://github.com/dbuenzli/ptime/issues"
  depends: [
    "ocaml" {>= "4.01.0"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build}
    "result"
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
  dev-repo: "git+http://erratique.ch/repos/ptime.git"
  url {
    src: "http://erratique.ch/software/ptime/releases/ptime-0.8.3.tbz"
    checksum: [
      "md5=bf84f6bfedce30349cffc9eb52ac7574"
     
  "sha256=84643c415a8b6a4eef087bb6024c95afa932a636f31b3bcffb3135fba6ae51a2"
     
  "sha512=5e1cf34dfb3e41b1cddc65d23da786a36293fc11cc31d9bc568bfd5bf280fe825666237983eecbcb0ddad340710008688178d3047e1a5ee5e8cecdb01ea28b00"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  result, js_of_ocaml ? null }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.01.0") >= 0;

stdenv.mkDerivation rec {
  pname = "ptime";
  version = "0.8.3";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://erratique.ch/software/ptime/releases/ptime-0.8.3.tbz";
    sha256 = "18jimskgnd9izg7kn6zk6sk35adgjm605dkv13plwslbb90kqr44";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg result ]
  ++
  stdenv.lib.optional
  (js_of_ocaml
  !=
  null)
  js_of_ocaml;
  propagatedBuildInputs = [
    ocaml result ]
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
