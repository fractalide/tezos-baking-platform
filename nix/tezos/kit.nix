{ lib, stdenv, tezos-src, ocaml, findlib, jbuilder, bigstring, cstruct, hex, ocplib-endian, re, zarith, calendar, cmdliner, ezjsonm, lwt, mtime, ipaddr, uri, cohttp-lwt-unix, ocp-ocamlres, rresult, ocaml-hidapi, irmin }:

assert lib.versionAtLeast (lib.getVersion bigstring) "0.1.1";
assert lib.versionAtLeast (lib.getVersion cstruct) "3.2.1";
assert lib.versionAtLeast (lib.getVersion ocplib-endian) "1.0";
assert lib.versionAtLeast (lib.getVersion re) "1.7.2";
assert lib.versionAtLeast (lib.getVersion zarith) "1.7";

let ifPathExists = p: c: if lib.isStorePath (builtins.dirOf p) then "[ -e ${p} ] && ${c}" else lib.optionalString (builtins.pathExists p) c; in
stdenv.mkDerivation rec {
  name = "tezos-${version}";
  version = "0.0.0";
  srcs = builtins.map (p: tezos-src + p) [ /src /vendors /scripts /docs ];
  postUnpack = lib.concatMapStrings
    (p: ifPathExists (tezos-src + p)
      "cp ${tezos-src + p} ${lib.escapeShellArg (builtins.baseNameOf p)}\n")
    [ /active_protocol_versions /dune /dune-workspace
      /jbuild /Makefile ];
  sourceRoot = ".";
  buildInputs = [ ocaml findlib jbuilder bigstring cstruct hex ocplib-endian re zarith calendar cmdliner ezjsonm lwt mtime ipaddr uri cohttp-lwt-unix ocp-ocamlres rresult ocaml-hidapi irmin ];

  makeFlags = [ "current_opam_version=2.0.0" "current_ocaml_version=${ocaml.version}" ];

  # createFindlibDestdir = true;

  # installPhase = "${opam}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR";

  meta = {
    # homepage = https://github.com/janestreet/jbuilder;
    description = "Tezos blockchain reference implementation.";
    # maintainers = [ stdenv.lib.maintainers.vbgl ];
    # license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
