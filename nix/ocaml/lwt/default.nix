/*opam-version: "2.0"
  name: "lwt"
  version: "3.3.0"
  synopsis: "Promises, concurrency, and parallelized I/O"
  description: """
  A promise is a value that may become determined in the future.
  
  Lwt provides typed, composable promises. Promises that are resolved by I/O
  are
  resolved by Lwt in parallel.
  
  Meanwhile, OCaml code, including code creating and waiting on promises,
  runs in
  a single thread by default. This reduces the need for locks or
  other
  synchronization primitives. Code can be run in parallel on an opt-in
  basis."""
  maintainer: [
    "Anton Bachin <antonbachin@yahoo.com>"
    "Mauricio Fernandez <mfp@acm.org>"
    "Simon Cruanes <simon.cruanes.2007@m4x.org>"
  ]
  authors: ["Jérôme Vouillon" "Jérémie Dimino"]
  license: "LGPL with OpenSSL linking exception"
  homepage: "https://github.com/ocsigen/lwt"
  doc: "https://ocsigen.org/lwt/manual/"
  bug-reports: "https://github.com/ocsigen/lwt/issues"
  depends: [
    "ocaml" {>= "4.02.0"}
    "cppo" {build & >= "1.1.0"}
    "jbuilder" {build & >= "1.0+beta14"}
    "ocamlfind" {build & >= "1.7.3-1"}
    "ocaml-migrate-parsetree"
    "ppx_tools_versioned" {>= "5.0.1"}
    "result"
  ]
  depopts: ["base-threads" "base-unix" "camlp4" "conf-libev"]
  conflicts: [
    "ocaml-variants" {= "4.02.1+BER"}
  ]
  build: [
    [
      "ocaml"
      "src/util/configure.ml"
      "-use-libev"
      "%{conf-libev:installed}%"
      "-use-camlp4"
      "%{camlp4:installed}%"
    ]
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["ocaml" "src/util/install_filter.ml"]
    ["jbuilder" "runtest" "-p" name] {with-test}
  ]
  messages: [
    "For the PPX, please install package lwt_ppx" {!lwt_ppx:installed}
    "For the Camlp4 syntax, please install package lwt_camlp4"
      {camlp4:installed & !lwt_camlp4:installed}
    "For Lwt_log and Lwt_daemon, please install package lwt_log"
      {!lwt_log:installed}
  ]
  dev-repo: "git+https://github.com/ocsigen/lwt.git"
  url {
    src: "https://github.com/ocsigen/lwt/archive/3.3.0.tar.gz"
    checksum: "md5=47bdf4b429da94419941ebe4354f505f"
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, cppo, jbuilder, findlib,
  ocaml-migrate-parsetree, ppx_tools_versioned, result, base-threads ? null,
  base-unix ? null, camlp4 ? null, conf-libev ? null, ncurses }:
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion cppo) "1.1.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder)
  "1.0+beta14";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion findlib) "1.7.3-1";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ppx_tools_versioned)
  "5.0.1";

stdenv.mkDerivation rec {
  pname = "lwt";
  version = "3.3.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/ocsigen/lwt/archive/3.3.0.tar.gz";
    sha256 = "1syk6bw5ki45ghdf8lr3ifsdnhgvwdbbmnqy57hbfaw2i5xv0552";
  };
  buildInputs = [
    ocaml cppo jbuilder findlib ocaml-migrate-parsetree ppx_tools_versioned
    result ]
  ++
  stdenv.lib.optional
  (base-threads
  !=
  null)
  base-threads
  ++
  stdenv.lib.optional
  (base-unix
  !=
  null)
  base-unix
  ++
  stdenv.lib.optional
  (camlp4
  !=
  null)
  camlp4
  ++
  stdenv.lib.optional
  (conf-libev
  !=
  null)
  conf-libev
  ++
  [
    ncurses ];
  propagatedBuildInputs = [
    ocaml cppo jbuilder findlib ocaml-migrate-parsetree ppx_tools_versioned
    result ]
  ++
  stdenv.lib.optional
  (base-threads
  !=
  null)
  base-threads
  ++
  stdenv.lib.optional
  (base-unix
  !=
  null)
  base-unix
  ++
  stdenv.lib.optional
  (camlp4
  !=
  null)
  camlp4
  ++
  stdenv.lib.optional
  (conf-libev
  !=
  null)
  conf-libev
  ++
  [
    ncurses ];
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'src/util/configure.ml'" "'-use-libev'"
      "${if conf-libev != null then "true" else "false"}" "'-use-camlp4'" "${if
                                                                    camlp4 !=
                                                                    null
                                                                    then
                                                                     
                                                                    "true"
                                                                    else
                                                                     
                                                                    "false"}" ] [ "'jbuilder'"
                                                                    "'build'"
                                                                    "'-p'"
                                                                    pname
                                                                    "'-j'"
                                                                    "1" ] [ "'ocaml'"
                                                                    "'src/util/install_filter.ml'"
                                                                    ] (stdenv.lib.optionals doCheck [ "'jbuilder'"
                                                                    "'runtest'"
                                                                    "'-p'"
                                                                    pname ]) ];
      preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
      [ ];
      installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
      createFindlibDestdir = true;
    }
