/*opam-version: "2.0"
  name: "uchar"
  version: "0.0.2"
  synopsis: "Compatibility library for OCaml's Uchar module"
  description: """
  The `uchar` package provides a compatibility library for the
  [`Uchar`][1] module introduced in OCaml 4.03.
  
  The `uchar` package is distributed under the license of the OCaml
  compiler. See [LICENSE](LICENSE) for details.
  
  [1]:
  http://caml.inria.fr/pub/docs/manual-ocaml/libref/Uchar.html"""
  maintainer: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  authors: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  license: "typeof OCaml system"
  tags: ["text" "character" "unicode" "compatibility"
  "org:ocaml.org"]
  homepage: "http://ocaml.org"
  doc: "https://ocaml.github.io/uchar/"
  bug-reports: "https://github.com/ocaml/uchar/issues"
  depends: [
    "ocaml" {>= "3.12.0"}
    "ocamlbuild" {build}
  ]
  build: [
    ["ocaml" "pkg/git.ml"]
    [
      "ocaml"
      "pkg/build.ml"
      "native=%{ocaml:native}%"
      "native-dynlink=%{ocaml:native-dynlink}%"
    ]
  ]
  dev-repo: "git+https://github.com/ocaml/uchar.git"
  url {
    src:
     
  "https://github.com/ocaml/uchar/releases/download/v0.0.2/uchar-0.0.2.tbz"
    checksum: "md5=c9ba2c738d264c420c642f7bb1cf4a36"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, ocamlbuild, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "3.12.0";

stdenv.mkDerivation rec {
  pname = "uchar";
  version = "0.0.2";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml/uchar/releases/download/v0.0.2/uchar-0.0.2.tbz";
    sha256 = "1w2saw7zanf9m9ffvz2lvcxvlm118pws2x1wym526xmydhqpyfa7";
  };
  buildInputs = [
    ocaml ocamlbuild findlib ];
  propagatedBuildInputs = [
    ocaml ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'ocaml'" "'pkg/git.ml'" ] [
      "'ocaml'" "'pkg/build.ml'"
      "'native='${if !stdenv.isMips then "true" else "false"}" "'native-dynlink='${if
                                                                    !stdenv.isMips
                                                                    then
                                                                     
                                                                    "true"
                                                                    else
                                                                     
                                                                    "false"}" ] ];
      preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
      [ ];
      installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
      createFindlibDestdir = true;
    }
