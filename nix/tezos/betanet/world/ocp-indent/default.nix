/*opam-version: "2.0"
  name: "ocp-indent"
  version: "1.6.1"
  synopsis: "A simple tool to indent OCaml programs"
  description: """
  Ocp-indent is based on an approximate, tolerant OCaml parser and a simple
  stack
  machine ; this is much faster and more reliable than using regexps. Presets
  and
  configuration options available, with the possibility to set them
  project-wide.
  Supports most common syntax extensions, and extensible for
  others.
  
  Includes:
  
  * An indentor program, callable from the command-line or from within
  editors
  * Bindings for popular editors
  * A library that can be directly used by editor writers, or just
  for
  approximate parsing."""
  maintainer: "contact@ocamlpro.com"
  authors: [
    "Louis Gesbert <louis.gesbert@ocamlpro.com>"
    "Thomas Gazagnaire <thomas@gazagnaire.org>"
    "Jun Furuse"
  ]
  license: "LGPL"
  tags: ["org:ocamlpro" "org:typerex"]
  homepage: "http://www.typerex.org/ocp-indent.html"
  bug-reports: "https://github.com/OCamlPro/ocp-indent/issues"
  depends: [
    "ocaml"
    "ocp-build" {build & >= "1.99.6-beta"}
    "cmdliner" {>= "1.0.0"}
    "base-bytes"
  ]
  build: [
    ["./configure" "--prefix" prefix]
    [make]
  ]
  post-messages:
    """
  This package requires additional configuration for use in editors. Install
  package 'user-setup', or manually:
  
  * for Emacs, add these lines to ~/.emacs:
    (add-to-list 'load-path "%{share}%/emacs/site-lisp")
    (require 'ocp-indent)
  
  * for Vim, add this line to ~/.vimrc:
    set rtp^="%{share}%/ocp-indent/vim\""""
      {success & !user-setup:installed}
  dev-repo: "git+https://github.com/OCamlPro/ocp-indent.git"
  url {
    src: "https://github.com/OCamlPro/ocp-indent/archive/1.6.1.tar.gz"
    checksum: [
      "md5=935d03f4f6376d687c46f350ff5eecdd"
     
  "sha256=f314fa1d6f1ece652a291b552f1f49ec6439c9c3f5e7819e16de5c08d4588fe2"
     
  "sha512=6e4274b3ce26f18d33bc37e9f4a9ed433be12ea96b017c8aed224211db3aef2f40ecaf2eaf892a4d9575e79ea44d9bb1b8798b8410575c7768159341f79b9ec0"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, ocp-build, cmdliner,
  base-bytes, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocp-build "1.99.6-beta") >= 0;
assert (vcompare cmdliner "1.0.0") >= 0;

stdenv.mkDerivation rec {
  pname = "ocp-indent";
  version = "1.6.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/OCamlPro/ocp-indent/archive/1.6.1.tar.gz";
    sha256 = "1qlgb3a0hp6y2sg83rzmqg4kjr7c94gjym8v54m6bkhydwfzl57k";
  };
  buildInputs = [
    ocaml ocp-build cmdliner base-bytes findlib ];
  propagatedBuildInputs = [
    ocaml ocp-build cmdliner base-bytes ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'./configure'" "'--prefix'" "$out" ] [ "make" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
