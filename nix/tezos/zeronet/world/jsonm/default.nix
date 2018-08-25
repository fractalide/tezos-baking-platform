/*opam-version: "2.0"
  name: "jsonm"
  version: "1.0.1"
  synopsis: "Non-blocking streaming JSON codec for OCaml"
  description: """
  Jsonm is a non-blocking streaming codec to decode and encode the JSON
  data format. It can process JSON text without blocking on IO and
  without a complete in-memory representation of the data.
  
  The alternative "uncut" codec also processes whitespace and
  (non-standard) JSON with JavaScript comments.
  
  Jsonm is made of a single module and depends on [Uutf][uutf]. It is
  distributed
  under the ISC license.
  
  [uutf]: http://erratique.ch/software/uutf"""
  maintainer: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  authors: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  license: "ISC"
  tags: ["json" "codec" "org:erratique"]
  homepage: "http://erratique.ch/software/jsonm"
  doc: "http://erratique.ch/software/jsonm/doc/Jsonm"
  bug-reports: "https://github.com/dbuenzli/jsonm/issues"
  depends: [
    "ocaml" {>= "4.01.0"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build}
    "uchar"
    "uutf" {>= "1.0.0"}
  ]
  build: ["ocaml" "pkg/pkg.ml" "build" "--pinned" "%{pinned}%"]
  dev-repo: "git+http://erratique.ch/repos/jsonm.git"
  url {
    src: "http://erratique.ch/software/jsonm/releases/jsonm-1.0.1.tbz"
    checksum: [
      "md5=e2ca39eaefd55b8d155c4f1ec5885311"
     
  "sha256=3c09562ed43b617d8b6d9522a249ff770228e7d6de9f9508b72e84d52b6be684"
     
  "sha512=e86e225073b429f71063af14ad39b87498609db6a122b39e1a739c5b77fcde487bf6b17235b2f9742b7d22aca0f6d475fdba1b0bab2a6329cf7e681fe43d31a6"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  uchar, uutf }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.01.0") >= 0;
assert (vcompare uutf "1.0.0") >= 0;

stdenv.mkDerivation rec {
  pname = "jsonm";
  version = "1.0.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://erratique.ch/software/jsonm/releases/jsonm-1.0.1.tbz";
    sha256 = "1176dcmxb11fnw49b7yysvkjh0kpzx4s48lmdn5psq9vshp5c29w";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg uchar uutf ];
  propagatedBuildInputs = [
    ocaml uchar uutf ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
