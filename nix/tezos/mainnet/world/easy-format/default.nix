/*opam-version: "2.0"
  name: "easy-format"
  version: "1.3.1"
  synopsis:
    "High-level and functional interface to the Format module of the OCaml
  standard library"
  maintainer: "martin@mjambon.com"
  authors: "Martin Jambon"
  homepage: "http://mjambon.com/easy-format.html"
  bug-reports: "https://github.com/mjambon/easy-format/issues"
  depends: [
    "ocaml" {>= "4.02.3"}
    "jbuilder" {build}
  ]
  build: [
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name] {with-test}
  ]
  dev-repo: "git+https://github.com/mjambon/easy-format.git"
  url {
    src: "https://github.com/mjambon/easy-format/archive/v1.3.1.tar.gz"
    checksum: [
      "md5=4e163700fb88fdcd6b8976c3a216c8ea"
     
  "sha256=489d55ea5de171cea2d7e2114bcd5cebd1fcbf89f839fbf3757769507502e1f0"
     
  "sha512=d8d5dc3ca53a84dc242869a09b3f485ca43a8260c6bae79c9e1cbd3751ddc3c4e5cca7582b987ff12980adb7a385261f53169349c0334782ea5c3412d4ed3ab2"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.3") >= 0;

stdenv.mkDerivation rec {
  pname = "easy-format";
  version = "1.3.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mjambon/easy-format/archive/v1.3.1.tar.gz";
    sha256 = "1w7109sm0sbpfprznfgqi6zzrlgbbk6ln4g2syicwwg1bpm5b7a8";
  };
  buildInputs = [
    ocaml jbuilder findlib ];
  propagatedBuildInputs = [
    ocaml ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] (stdenv.lib.optionals
    doCheck [ "'jbuilder'" "'runtest'" "'-p'" pname ]) ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
