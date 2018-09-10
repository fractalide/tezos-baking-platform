/*opam-version: "2.0"
  name: "topkg"
  version: "0.9.1"
  synopsis: "The transitory OCaml software packager"
  description: """
  Topkg is a packager for distributing OCaml software. It provides an
  API to describe the files a package installs in a given build
  configuration and to specify information about the package's
  distribution, creation and publication procedures.
  
  The optional topkg-care package provides the `topkg` command line tool
  which helps with various aspects of a package's life cycle: creating
  and linting a distribution, releasing it on the WWW, publish
  its
  documentation, add it to the OCaml opam repository, etc.
  
  Topkg is distributed under the ISC license and has **no**
  dependencies. This is what your packages will need as a
  *build*
  dependency.
  
  Topkg-care is distributed under the ISC license it depends on
  [fmt][fmt], [logs][logs], [bos][bos],
  [cmdliner][cmdliner],
  [webbrowser][webbrowser] and `opam-format`.
  
  [fmt]: http://erratique.ch/software/fmt
  [logs]: http://erratique.ch/software/logs
  [bos]: http://erratique.ch/software/bos
  [cmdliner]: http://erratique.ch/software/cmdliner
  [webbrowser]: http://erratique.ch/software/webbrowser"""
  maintainer: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  authors: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  license: "ISC"
  tags: ["packaging" "ocamlbuild" "org:erratique"]
  homepage: "http://erratique.ch/software/topkg"
  doc: "http://erratique.ch/software/topkg/doc"
  bug-reports: "https://github.com/dbuenzli/topkg/issues"
  depends: [
    "ocaml" {>= "4.01.0"}
    "ocamlfind" {build & >= "1.6.1"}
    "ocamlbuild"
    "result"
  ]
  build: [
    "ocaml" "pkg/pkg.ml" "build" "--pkg-name" name "--dev-pkg"
  "%{pinned}%"
  ]
  dev-repo: "git+http://erratique.ch/repos/topkg.git"
  url {
    src: "http://erratique.ch/software/topkg/releases/topkg-0.9.1.tbz"
    checksum: [
      "md5=8978a0595db1a22e4251ec62735d4b84"
     
  "sha256=a6fb7a308374c50201c0998ccb1ee878fffe4c131a73eef4833da0ebebfa99ea"
     
  "sha512=10c4af2dfae0757686179ca2ff843add95d6f911121a345ab7fbf2aa901e0384b2aaf5152e04328edc791fd0b9fa81886a398d80f056f9dc3fad7280916bf052"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild,
  ocaml-result }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.01.0") >= 0;
assert (vcompare findlib "1.6.1") >= 0;

stdenv.mkDerivation rec {
  pname = "topkg";
  version = "0.9.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://erratique.ch/software/topkg/releases/topkg-0.9.1.tbz";
    sha256 = "1slrzbmyp81xhgsfwwqs2d6gxzvqx0gcp34rq00h5iblhcq7myx6";
  };
  buildInputs = [
    ocaml findlib ocamlbuild ocaml-result ];
  propagatedBuildInputs = [
    ocaml findlib ocamlbuild ocaml-result ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pkg-name'" pname "'--dev-pkg'"
      "false" ]
    ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
