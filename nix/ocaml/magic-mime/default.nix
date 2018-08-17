/*opam-version: "2.0"
  name: "magic-mime"
  version: "1.1.0"
  synopsis: "Map filenames to common MIME types"
  description: """
  This library contains a database of MIME types that maps filename
  extensions
  into MIME types suitable for use in many Internet protocols such as HTTP
  or
  e-mail.  It is generated from the `mime.types` file found in Unix systems,
  but
  has no dependency on a filesystem since it includes the contents of
  the
  database as an ML datastructure.
  
  For example, here's how to lookup MIME types in the [utop] REPL:
  
      #require "magic-mime";;
      Magic_mime.lookup "/foo/bar.txt";;
      - : bytes = "text/plain"
      Magic_mime.lookup "bar.css";;
      - : bytes = "text/css"
  
  ### Internals
  
  The following files need to be edited to add MIME types:
  
  - mime.types: this is obtained by synching from the Apache Foundation's
   
  [mime.types](https://svn.apache.org/repos/asf/httpd/httpd/trunk/docs/conf/mime.types)
    in the Apache Subversion repository.
  - x-mime.types: these are the extension types, so non-standard `x-`
  prefixes are used here.
  - file.types: full filenames of common occurrences that are useful to map
  onto a MIME type.
    OCaml-specific things like `opam` files show up here."""
  maintainer: "Anil Madhavapeddy <anil@recoil.org>"
  authors: ["Anil Madhavapeddy" "Maxence Guesdon"]
  license: "ISC"
  homepage: "https://github.com/mirage/ocaml-magic-mime"
  doc: "https://mirage.github.io/ocaml-magic-mime"
  bug-reports: "https://github.com/mirage/ocaml-magic-mime/issues"
  depends: [
    "ocaml" {>= "4.03.0"}
    "jbuilder" {build & >= "1.0+beta9"}
  ]
  build: [
    ["jbuilder" "subst"] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
  ]
  dev-repo: "git+https://github.com/mirage/ocaml-magic-mime.git"
  url {
    src:
     
  "https://github.com/mirage/ocaml-magic-mime/releases/download/v1.1.0/magic-mime-1.1.0.tbz"
    checksum: "md5=341ab5133c2e17ca645f23a0149025d1"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, findlib }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.03.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta9";

stdenv.mkDerivation rec {
  pname = "magic-mime";
  version = "1.1.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/ocaml-magic-mime/releases/download/v1.1.0/magic-mime-1.1.0.tbz";
    sha256 = "0ryl4ipz0g84n7cgaz7v8r8m7rj8hwqk18yi339lhjcqjzpm06dr";
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
