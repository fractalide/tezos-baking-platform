/*opam-version: "2.0"
  name: "logs"
  version: "0.6.2"
  synopsis: "Logging infrastructure for OCaml"
  description: """
  Logs provides a logging infrastructure for OCaml. Logging is performed
  on sources whose reporting level can be set independently. Log
  message
  report is decoupled from logging and is handled by a reporter.
  
  A few optional log reporters are distributed with the base library and
  the API easily allows to implement your own.
  
  `Logs` depends only on the `result` compatibility package. The
  optional `Logs_fmt` reporter on OCaml formatters depends on [Fmt][fmt].
  The optional `Logs_browser` reporter that reports to the web browser
  console depends on [js_of_ocaml][jsoo]. The optional `Logs_cli` library
  that provides command line support for controlling Logs depends
  on
  [`Cmdliner`][cmdliner]. The optional `Logs_lwt` library that provides Lwt
  logging
  functions depends on [`Lwt`][lwt]
  
  Logs and its reporters are distributed under the ISC license.
  
  [fmt]: http://erratique.ch/software/fmt
  [jsoo]: http://ocsigen.org/js_of_ocaml/
  [cmdliner]: http://erratique.ch/software/cmdliner
  [lwt]: http://ocsigen.org/lwt/"""
  maintainer: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  authors: "Daniel Bünzli <daniel.buenzl i@erratique.ch>"
  license: "ISC"
  tags: ["log" "system" "org:erratique"]
  homepage: "http://erratique.ch/software/logs"
  doc: "http://erratique.ch/software/logs/doc"
  bug-reports: "https://github.com/dbuenzli/logs/issues"
  depends: [
    "ocaml" {>= "4.01.0"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build}
    "result"
    "mtime" {with-test}
  ]
  depopts: ["js_of_ocaml" "fmt" "cmdliner" "lwt"]
  conflicts: [
    "cmdliner" {< "0.9.8"}
  ]
  build: [
    "ocaml"
    "pkg/pkg.ml"
    "build"
    "--pinned"
    "%{pinned}%"
    "--with-js_of_ocaml"
    "%{js_of_ocaml:installed}%"
    "--with-fmt"
    "%{fmt:installed}%"
    "--with-cmdliner"
    "%{cmdliner:installed}%"
    "--with-lwt"
    "%{lwt:installed}%"
  ]
  dev-repo: "git+http://erratique.ch/repos/logs.git"
  url {
    src: "http://erratique.ch/software/logs/releases/logs-0.6.2.tbz"
    checksum: [
      "md5=19f824c02c83c6dddc3bfb6459e4743e"
     
  "sha256=a320ef34eda51694be23f2a383d83f9ae6a8430fd0ef8cec1fa8c58be5b10bce"
     
  "sha512=a669e373652bac6789626ad1d58e414c6d156c646bf0706c9d55b04151850113d45a5c28077707514d1a27d46fcc0f90b39b8652ce7a3980f79675e9874db8b4"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  ocaml-result, mtime ? null, js_of_ocaml ? null, fmt ? null,
  cmdliner ? null, lwt ? null }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.01.0") >= 0;
assert !((vcompare cmdliner "0.9.8") < 0);

stdenv.mkDerivation rec {
  pname = "logs";
  version = "0.6.2";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "http://erratique.ch/software/logs/releases/logs-0.6.2.tbz";
    sha256 = "1khbn7jqpid83zn8rvyh1x1sirls7zc878zj4fz985m5xlsfy853";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg ocaml-result ]
  ++
  stdenv.lib.optional
  doCheck
  mtime
  ++
  stdenv.lib.optional
  (js_of_ocaml
  !=
  null)
  js_of_ocaml
  ++
  stdenv.lib.optional
  (fmt
  !=
  null)
  fmt
  ++
  stdenv.lib.optional
  (cmdliner
  !=
  null)
  cmdliner
  ++
  stdenv.lib.optional
  (lwt
  !=
  null)
  lwt;
  propagatedBuildInputs = [
    ocaml ocaml-result ]
  ++
  stdenv.lib.optional
  doCheck
  mtime
  ++
  stdenv.lib.optional
  (js_of_ocaml
  !=
  null)
  js_of_ocaml
  ++
  stdenv.lib.optional
  (fmt
  !=
  null)
  fmt
  ++
  stdenv.lib.optional
  (cmdliner
  !=
  null)
  cmdliner
  ++
  stdenv.lib.optional
  (lwt
  !=
  null)
  lwt;
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false"
      "'--with-js_of_ocaml'"
      "${if js_of_ocaml != null then "true" else "false"}" "'--with-fmt'" "${if
                                                                    fmt !=
                                                                    null
                                                                    then
                                                                     
                                                                    "true"
                                                                    else
                                                                     
                                                                    "false"}" "'--with-cmdliner'" "${if
                                                                    cmdliner
                                                                    != null
                                                                    then
                                                                     
                                                                    "true"
                                                                    else
                                                                     
                                                                    "false"}" "'--with-lwt'" "${if
                                                                    lwt !=
                                                                    null
                                                                    then
                                                                     
                                                                    "true"
                                                                    else
                                                                     
                                                                    "false"}" ] ]; preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ") [ ]; installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done"; createFindlibDestdir = true; }
