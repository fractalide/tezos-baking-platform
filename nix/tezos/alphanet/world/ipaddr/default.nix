/*opam-version: "2.0"
  name: "ipaddr"
  version: "2.8.0"
  synopsis: "IP (and MAC) address manipulation"
  description: """
  A library for manipulation of IP (and MAC) address
  representations.
  
  Features:
  
   * Depends only on sexplib (conditionalization under consideration)
   * oUnit-based tests
   * IPv4 and IPv6 support
   * IPv4 and IPv6 CIDR prefix support
   * IPv4 and IPv6 [CIDR-scoped
  address](http://tools.ietf.org/html/rfc4291#section-2.3) support
   * `Ipaddr.V4` and `Ipaddr.V4.Prefix` modules are `Map.OrderedType`
   * `Ipaddr.V6` and `Ipaddr.V6.Prefix` modules are `Map.OrderedType`
   * `Ipaddr` and `Ipaddr.Prefix` modules are `Map.OrderedType`
   * `Ipaddr_unix` in findlib subpackage `ipaddr.unix` provides compatibility
  with the standard library `Unix` module
   * `Ipaddr_top` in findlib subpackage `ipaddr.top` provides top-level
  pretty printers (requires compiler-libs default since OCaml 4.0)
   * IP address scope classification
   * IPv4-mapped addresses in IPv6 (::ffff:0:0/96) are an embedding of IPv4
   * MAC-48 (Ethernet) address support
   * `Macaddr` is a `Map.OrderedType`
   * All types have sexplib serializers/deserializers"""
  maintainer: "sheets@alum.mit.edu"
  authors: ["David Sheets" "Anil Madhavapeddy" "Hugo Heuzard"]
  license: "ISC"
  tags: ["org:mirage" "org:xapi-project"]
  homepage: "https://github.com/mirage/ocaml-ipaddr"
  doc: "https://mirage.github.io/ocaml-ipaddr/"
  bug-reports: "https://github.com/mirage/ocaml-ipaddr/issues"
  depends: [
    "ocaml" {>= "4.03.0"}
    "jbuilder" {build & >= "1.0+beta7"}
    "base-bytes"
    "ppx_sexp_conv" {>= "v0.9.0"}
    "sexplib"
    "ounit" {with-test}
  ]
  depopts: ["base-unix"]
  build: [
    ["jbuilder" "subst" "-p" name] {pinned}
    ["jbuilder" "build" "-p" name "-j" jobs]
    ["jbuilder" "runtest" "-p" name "-j" jobs] {with-test}
  ]
  dev-repo: "git+https://github.com/mirage/ocaml-ipaddr.git"
  url {
    src:
     
  "https://github.com/mirage/ocaml-ipaddr/releases/download/2.8.0/ipaddr-2.8.0.tbz"
    checksum: [
      "md5=f3442867873b4b60d7860283ff98c3c8"
     
  "sha256=f27e93ea8b13083474cc995e37297ab6faf118f9381b2219aab972d0ae7e2886"
     
  "sha512=ff5d9c41a42bfc2517cb0bf668362ada93b46a124bc7b675b988dfbede2d79be704e441b5d474befe3f056fec882d087dae989486bddf8b742596c7656661ef5"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, jbuilder, base-bytes,
  ppx_sexp_conv, sexplib, ounit ? null, findlib, base-unix ? null }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.03.0") >= 0;
assert (vcompare jbuilder "1.0+beta7") >= 0;
assert (vcompare ppx_sexp_conv "v0.9.0") >= 0;

stdenv.mkDerivation rec {
  pname = "ipaddr";
  version = "2.8.0";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirage/ocaml-ipaddr/releases/download/2.8.0/ipaddr-2.8.0.tbz";
    sha256 = "11i8gspd0wmrm8cj46rqz4cg3ymng8lkfplrris3820kigm96zpj";
  };
  buildInputs = [
    ocaml jbuilder base-bytes ppx_sexp_conv sexplib ]
  ++
  stdenv.lib.optional
  doCheck
  ounit
  ++
  [
    findlib ]
  ++
  stdenv.lib.optional
  (base-unix
  !=
  null)
  base-unix;
  propagatedBuildInputs = [
    ocaml jbuilder base-bytes ppx_sexp_conv sexplib ]
  ++
  stdenv.lib.optional
  doCheck
  ounit
  ++
  stdenv.lib.optional
  (base-unix
  !=
  null)
  base-unix;
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [ "'jbuilder'" "'build'" "'-p'" pname "'-j'" "1" ] (stdenv.lib.optionals
    doCheck [ "'jbuilder'" "'runtest'" "'-p'" pname "'-j'" "1" ]) ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
