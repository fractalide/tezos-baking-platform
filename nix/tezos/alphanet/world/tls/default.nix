/*opam-version: "2.0"
  name: "tls"
  version: "0.9.1"
  synopsis: "Transport Layer Security purely in OCaml"
  description: """
  Transport Layer Security (TLS) is probably the most widely deployed
  security
  protocol on the Internet. It provides communication privacy to
  prevent
  eavesdropping, tampering, and message forgery. Furthermore, it
  optionally
  provides authentication of the involved endpoints. TLS is commonly deployed
  for
  securing web services ([HTTPS](http://tools.ietf.org/html/rfc2818)),
  emails,
  virtual private networks, and wireless networks.
  
  TLS uses asymmetric cryptography to exchange a symmetric key, and
  optionally
  authenticate (using X.509) either or both endpoints. It provides
  algorithmic
  agility, which means that the key exchange method, symmetric
  encryption
  algorithm, and hash algorithm are negotiated.
  
  Read [further](https://nqsb.io) and our [Usenix Security 2015
  paper](https://usenix15.nqsb.io)."""
  maintainer: [
    "Hannes Mehnert <hannes@mehnert.org>" "David Kaloper
  <david@numm.org>"
  ]
  authors: [
    "David Kaloper <david@numm.org>" "Hannes Mehnert
  <hannes@mehnert.org>"
  ]
  license: "BSD2"
  tags: "org:mirage"
  homepage: "https://github.com/mirleft/ocaml-tls"
  doc: "https://mirleft.github.io/ocaml-tls/doc"
  bug-reports: "https://github.com/mirleft/ocaml-tls/issues"
  depends: [
    "ocaml" {>= "4.02.2"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build}
    "ppx_sexp_conv" {< "v0.11.0"}
    "ppx_deriving"
    "ppx_cstruct" {>= "3.0.0"}
    "result"
    "cstruct" {>= "3.0.0"}
    "sexplib"
    "nocrypto" {>= "0.5.4"}
    "x509" {>= "0.6.1"}
    "cstruct-unix" {with-test & >= "3.0.0"}
    "ounit" {with-test}
  ]
  depopts: [
    "lwt"
    "mirage-flow-lwt"
    "mirage-kv-lwt"
    "mirage-clock"
    "ptime"
    "astring" {with-test}
  ]
  conflicts: [
    "lwt" {< "2.4.8"}
    "mirage-net-xen" {< "1.3.0"}
    "mirage-types" {< "3.0.0"}
    "sexplib" {= "v0.9.0"}
    "ptime" {< "0.8.1"}
  ]
  build: [
    [
      "ocaml"
      "pkg/pkg.ml"
      "build"
      "--pinned"
      "%{pinned}%"
      "--tests"
      "false"
      "--with-lwt"
      "%{lwt+ptime:installed}%"
      "--with-mirage"
      "%{mirage-flow-lwt+mirage-kv-lwt+mirage-clock+ptime:installed}%"
    ]
    [
      "ocaml"
      "pkg/pkg.ml"
      "build"
      "--pinned"
      "%{pinned}%"
      "--tests"
      "true"
      "--with-lwt"
      "%{lwt+ptime+astring:installed}%"
      "--with-mirage"
      "%{mirage-flow-lwt+mirage-kv-lwt+mirage-clock+ptime:installed}%"
    ] {with-test}
    ["ocaml" "pkg/pkg.ml" "test"] {with-test}
  ]
  dev-repo: "git+https://github.com/mirleft/ocaml-tls.git"
  url {
    src:
     
  "https://github.com/mirleft/ocaml-tls/releases/download/0.9.1/tls-0.9.1.tbz"
    checksum: [
      "md5=6540028f450dd753dc90d8a4ba6bb457"
     
  "sha256=2f9f0d47b9dccaba9da69f8fe6581b714d0d9cb7bddb46a1ac93dd83089a007d"
     
  "sha512=ed3a7e853fb2e5af3044fd01bf15a18cf2defbe2c2654ce185e975ba03b42631432b15e3e70469da95f8c1b96ea1ecbbd4d2ce6457c8a987bca49432d27b4a61"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  ppx_sexp_conv, ppx_deriving, ppx_cstruct, ocaml-result, cstruct, sexplib,
  nocrypto, x509, cstruct-unix ? null, ounit ? null, lwt ? null,
  mirage-flow-lwt ? null, mirage-kv-lwt ? null, mirage-clock ? null,
  ptime ? null, astring ? null }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.2") >= 0;
assert (vcompare ppx_sexp_conv "v0.11.0") < 0;
assert (vcompare ppx_cstruct "3.0.0") >= 0;
assert (vcompare cstruct "3.0.0") >= 0;
assert (vcompare nocrypto "0.5.4") >= 0;
assert (vcompare x509 "0.6.1") >= 0;
assert doCheck -> (vcompare cstruct-unix "3.0.0") >= 0;
assert !((vcompare lwt "2.4.8") < 0);
assert stdenv.lib.getVersion sexplib != "v0.9.0";
assert !((vcompare ptime "0.8.1") < 0);

stdenv.mkDerivation rec {
  pname = "tls";
  version = "0.9.1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/0.9.1/tls-0.9.1.tbz";
    sha256 = "0z80k8487pckmjhldnxxnyf0skbi3dcfd3wzlsfvmjnwp53hv7rg";
  };
  buildInputs = [
    ocaml findlib ocamlbuild topkg ppx_sexp_conv ppx_deriving ppx_cstruct
    ocaml-result cstruct sexplib nocrypto x509 cstruct-unix ]
  ++
  stdenv.lib.optional
  doCheck
  ounit
  ++
  stdenv.lib.optional
  (lwt
  !=
  null)
  lwt
  ++
  stdenv.lib.optional
  (mirage-flow-lwt
  !=
  null)
  mirage-flow-lwt
  ++
  stdenv.lib.optional
  (mirage-kv-lwt
  !=
  null)
  mirage-kv-lwt
  ++
  stdenv.lib.optional
  (mirage-clock
  !=
  null)
  mirage-clock
  ++
  stdenv.lib.optional
  (ptime
  !=
  null)
  ptime
  ++
  stdenv.lib.optional
  (astring
  !=
  null)
  astring;
  propagatedBuildInputs = [
    ocaml ppx_sexp_conv ppx_deriving ppx_cstruct ocaml-result cstruct sexplib
    nocrypto x509 cstruct-unix ]
  ++
  stdenv.lib.optional
  doCheck
  ounit
  ++
  stdenv.lib.optional
  (lwt
  !=
  null)
  lwt
  ++
  stdenv.lib.optional
  (mirage-flow-lwt
  !=
  null)
  mirage-flow-lwt
  ++
  stdenv.lib.optional
  (mirage-kv-lwt
  !=
  null)
  mirage-kv-lwt
  ++
  stdenv.lib.optional
  (mirage-clock
  !=
  null)
  mirage-clock
  ++
  stdenv.lib.optional
  (ptime
  !=
  null)
  ptime
  ++
  stdenv.lib.optional
  (astring
  !=
  null)
  astring;
  configurePhase = "true";
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false" "'--tests'"
      "'false'" "'--with-lwt'"
      "${if lwt != null && ptime != null then "true" else "false"}" "'--with-mirage'" "${if
                                                                    mirage-flow-lwt
                                                                    != null
                                                                    &&
                                                                    mirage-kv-lwt
                                                                    != null
                                                                    &&
                                                                    mirage-clock
                                                                    != null
                                                                    && ptime
                                                                    != null
                                                                    then
                                                                     
                                                                    "true"
                                                                    else
                                                                     
                                                                    "false"}" ] (stdenv.lib.optionals doCheck [ "'ocaml'"
                                                                    "'pkg/pkg.ml'"
                                                                    "'build'"
                                                                    "'--pinned'"
                                                                    "false"
                                                                    "'--tests'"
                                                                    "'true'"
                                                                    "'--with-lwt'"
                                                                    "${if
                                                                    lwt !=
                                                                    null &&
                                                                    ptime !=
                                                                    null &&
                                                                    astring
                                                                    != null
                                                                    then
                                                                     
                                                                    "true"
                                                                    else
                                                                     
                                                                    "false"}" "'--with-mirage'" "${if
                                                                    mirage-flow-lwt
                                                                    != null
                                                                    &&
                                                                    mirage-kv-lwt
                                                                    != null
                                                                    &&
                                                                    mirage-clock
                                                                    != null
                                                                    && ptime
                                                                    != null
                                                                    then
                                                                     
                                                                    "true"
                                                                    else
                                                                     
                                                                    "false"}" ]) (stdenv.lib.optionals doCheck [ "'ocaml'"
                                                                    "'pkg/pkg.ml'"
                                                                    "'test'" ]) ];
                                                                    preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
                                                                    [ ];
                                                                    installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
                                                                    createFindlibDestdir = true; }
