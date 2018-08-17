/*opam-version: "2.0"
  name: "afl-persistent"
  version: "1.2"
  synopsis: "use afl-fuzz in persistent mode"
  description: """
  afl-fuzz normally works by repeatedly fork()ing the program being
  tested. using this package, you can run afl-fuzz in 'persistent mode',
  which avoids repeated forking and is much faster."""
  maintainer: "stephen.dolan@cl.cam.ac.uk"
  authors: "Stephen Dolan"
  license: "MIT"
  homepage: "https://github.com/stedolan/ocaml-afl-persistent"
  bug-reports:
  "https://github.com/stedolan/ocaml-afl-persistent/issues"
  depends: [
    "ocaml" {>= "4.00"}
    "ocamlfind"
    "base-unix"
  ]
  build: "./build.sh"
  post-messages: [
    """
  afl-persistent is installed, but since AFL instrumentation is not
  available
  with this OCaml compiler, instrumented fuzzing with afl-fuzz won't work.
  
  To use instrumented fuzzing, switch to an OCaml version supporting AFL,
  such
  as 4.04.0+afl."""
      {success & !afl-available}
    """
  afl-persistent is installed, but since the current OCaml compiler does
  not enable AFL instrumentation by default, most packages will not
  be
  instrumented and fuzzing with afl-fuzz may not be effective.
  
  To globally enable AFL instrumentation, use an OCaml switch such
  as
  4.04.0+afl."""
      {success & afl-available & !afl-always}
  ]
  dev-repo: "git+https://github.com/stedolan/ocaml-afl-persistent.git"
  url {
    src:
  "https://github.com/stedolan/ocaml-afl-persistent/archive/v1.2.tar.gz"
    checksum: "md5=1c26b72e0646402f6f5daac91a70c4cf"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, base-unix }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.00";

stdenv.mkDerivation rec {
  pname = "afl-persistent";
  version = "1.2";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/stedolan/ocaml-afl-persistent/archive/v1.2.tar.gz";
    sha256 = "1697ncdyivwv3h7zi9p2mqdckyavpywpwz83s6s3y5577kzbas0k";
  };
  buildInputs = [
    ocaml findlib base-unix ];
  propagatedBuildInputs = [
    ocaml findlib base-unix ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'./build.sh'" ] ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
