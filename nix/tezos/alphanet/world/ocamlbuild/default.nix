/*opam-version: "2.0"
  name: "ocamlbuild"
  version: "0.12.0"
  synopsis:
    "OCamlbuild is a build system with builtin rules to easily build most
  OCaml projects."
  maintainer: "Gabriel Scherer <gabriel.scherer@gmail.com>"
  authors: ["Nicolas Pouillard" "Berke Durak"]
  license: "LGPL-2 with OCaml linking exception"
  homepage: "https://github.com/ocaml/ocamlbuild/"
  doc:
  "https://github.com/ocaml/ocamlbuild/blob/master/manual/manual.adoc"
  bug-reports: "https://github.com/ocaml/ocamlbuild/issues"
  depends: [
    "ocaml" {>= "4.03"}
  ]
  conflicts: [
    "base-ocamlbuild"
    "ocamlfind" {< "1.6.2"}
  ]
  build: [
    [
      make
      "-f"
      "configure.make"
      "all"
      "OCAMLBUILD_PREFIX=%{prefix}%"
      "OCAMLBUILD_BINDIR=%{bin}%"
      "OCAMLBUILD_LIBDIR=%{lib}%"
      "OCAMLBUILD_MANDIR=%{man}%"
      "OCAML_NATIVE=%{ocaml:native}%"
      "OCAML_NATIVE_TOOLS=%{ocaml:native}%"
    ]
    [make "check-if-preinstalled" "all" "opam-install"]
  ]
  dev-repo: "git+https://github.com/ocaml/ocamlbuild.git"
  url {
    src: "https://github.com/ocaml/ocamlbuild/archive/0.12.0.tar.gz"
    checksum: [
      "md5=442baa19470bd49150f153122e22907b"
     
  "sha256=d9de56aa961f585896844b24c6f7695a9e7ad9d00263fdfe50a17f38b13b9ce1"
     
  "sha512=0755a8410a1e083d344e2389bbff06ae2ad5daaf9b186147fd0d2fa094bdc3a2e8e94e2a1e666a63276d10899274b905535300f47d50e747e86f17cf562abe08"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.03") >= 0;
assert !((vcompare findlib "1.6.2") < 0);

stdenv.mkDerivation rec {
  pname = "ocamlbuild";
  version = "0.12.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocaml/ocamlbuild/archive/0.12.0.tar.gz";
    sha256 = "1qcw7fqkhzx1a3zgsqq2s3cpm7jsd7vwc92bhjb5hn0zjsm5dpnr";
  };
  buildInputs = [
    ocaml findlib ];
  propagatedBuildInputs = [
    ocaml ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "make" "'-f'" "'configure.make'" "'all'" "'OCAMLBUILD_PREFIX='$out"
      "'OCAMLBUILD_BINDIR='$out/bin" "'OCAMLBUILD_LIBDIR='$OCAMLFIND_DESTDIR"
      "'OCAMLBUILD_MANDIR='$out/man"
      "'OCAML_NATIVE='${if !stdenv.isMips then "true" else "false"}" "'OCAML_NATIVE_TOOLS='${if
                                                                    !stdenv.isMips
                                                                    then
                                                                     
                                                                    "true"
                                                                    else
                                                                     
                                                                    "false"}" ] [ "make"
                                                                    "'check-if-preinstalled'"
                                                                    "'all'"
                                                                    "'opam-install'"
                                                                    ] ];
      preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
      [ ];
      installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
      createFindlibDestdir = true;
    }
