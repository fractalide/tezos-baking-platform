/*opam-version: "2.0"
  name: "nocrypto"
  version: "0.5.4-1"
  synopsis: "Simpler crypto"
  description: """
  nocrypto is a small cryptographic library that puts emphasis on the
  applicative
  style and ease of use. It includes basic ciphers (AES, 3DES, RC4), hashes
  (MD5,
  SHA1, SHA2), public-key primitives (RSA, DSA, DH) and a strong RNG
  (Fortuna).
  
  RSA timing attacks are countered by blinding. AES timing attacks are
  avoided by
  delegating to AES-NI."""
  maintainer: "David Kaloper <david@numm.org>"
  authors: "David Kaloper <david@numm.org>"
  license: "ISC"
  tags: "org:mirage"
  homepage: "https://github.com/mirleft/ocaml-nocrypto"
  doc: "https://mirleft.github.io/ocaml-nocrypto/doc"
  bug-reports: "https://github.com/mirleft/ocaml-nocrypto/issues"
  depends: [
    "ocaml" {>= "4.02.0"}
    "ocamlfind" {build}
    "ocamlbuild" {build}
    "topkg" {build}
    "cpuid" {build}
    "ocb-stubblr" {build}
    "ppx_deriving" {build}
    "ppx_sexp_conv" {>= "113.33.01" & != "v0.11.0"}
    "ounit" {with-test}
    "cstruct" {>= "2.4.0"}
    "cstruct-lwt"
    "zarith"
    "lwt"
    "sexplib"
    "mirage-no-xen"
    "mirage-no-solo5"
  ]
  conflicts: [
    "topkg" {< "0.9.1"}
    "ocb-stubblr" {< "0.1.0"}
    "mirage-xen" {< "2.2.0"}
    "sexplib" {= "v0.9.0"}
  ]
  available: os != "freebsd" & os != "openbsd"
  build: [
    "ocaml"
    "pkg/pkg.ml"
    "build"
    "--pinned"
    "%{pinned}%"
    "--tests"
    "false"
    "--jobs"
    "1"
    "--with-lwt"
    "%{lwt:installed}%"
    "--xen"
    "%{mirage-xen:installed}%"
    "--freestanding"
    "%{mirage-solo5:installed}%"
  ]
  patches: [
    "0001-add-missing-runtime-dependencies-in-_tags.patch"
    "0002-add-ppx_sexp_conv-as-a-runtime-dependency-in-the-pac.patch"
    "0003-Auto-detect-ppx_sexp_conv-runtime-library.patch"
    "0004-pack-package-workaround-ocamlbuild-272.patch"
  ]
  dev-repo: "git+https://github.com/mirleft/ocaml-nocrypto.git"
  extra-files: [
    [
      "0004-pack-package-workaround-ocamlbuild-272.patch"
      "md5=94615e4a8d5976e9e75c3b031d3484f1"
    ]
    [
      "0003-Auto-detect-ppx_sexp_conv-runtime-library.patch"
      "md5=871b3f904cf87527b7390993d5598884"
    ]
    [
      "0002-add-ppx_sexp_conv-as-a-runtime-dependency-in-the-pac.patch"
      "md5=06962f4f2f5b4c3f1e39293b3d3528f2"
    ]
    [
      "0001-add-missing-runtime-dependencies-in-_tags.patch"
      "md5=ae679a096e14c0a0ecb881bc7432cc2a"
    ]
  ]
  url {
    src:
     
  "https://github.com/mirleft/ocaml-nocrypto/releases/download/v0.5.4/nocrypto-0.5.4.tbz"
    checksum: [
      "md5=c331a7a4d2a563d1d5ed581aeb849011"
     
  "sha256=8f720c8753136706ae14d46ba85e27f482a8b3e9ceccf08b0de63348618a507f"
     
  "sha512=c0c010ec6f3fa2c7f1c8a26e3d9ee33b30e5311e7b10cf03a35923fa717034d36ca31417e5d53953a3dc6cad45901e9871d9851bb62f1626c3a14dd4e595d589"
    ]
  }*/
{ doCheck ? false, stdenv, opam, fetchurl, ocaml, findlib, ocamlbuild, topkg,
  cpuid, ocb-stubblr, ppx_deriving, ppx_sexp_conv, ounit ? null, cstruct,
  cstruct-lwt, zarith, lwt, sexplib, mirage-no-xen, mirage-no-solo5 }:
let vcompare = stdenv.lib.versioning.debian.version.compare; in
assert (vcompare ocaml "4.02.0") >= 0;
assert (vcompare ppx_sexp_conv "113.33.01") >= 0 && stdenv.lib.getVersion
  ppx_sexp_conv != "v0.11.0";
assert (vcompare cstruct "2.4.0") >= 0;
assert !((vcompare topkg "0.9.1") < 0);
assert !((vcompare ocb-stubblr "0.1.0") < 0);
assert stdenv.lib.getVersion sexplib != "v0.9.0";

stdenv.mkDerivation rec {
  pname = "nocrypto";
  version = "0.5.4-1";
  name = "${pname}-${version}";
  inherit doCheck;
  src = fetchurl
  {
    url = "https://github.com/mirleft/ocaml-nocrypto/releases/download/v0.5.4/nocrypto-0.5.4.tbz";
    sha256 = "0zshi9hlhcz61n5z1k6fx6rsi0pl4xgahsyl2jp0crqkaf3hqwlg";
  };
  postUnpack = "ln -sv ${./0004-pack-package-workaround-ocamlbuild-272.patch} \"$sourceRoot\"/0004-pack-package-workaround-ocamlbuild-272.patch\nln -sv ${./0003-Auto-detect-ppx_sexp_conv-runtime-library.patch} \"$sourceRoot\"/0003-Auto-detect-ppx_sexp_conv-runtime-library.patch\nln -sv ${./0002-add-ppx_sexp_conv-as-a-runtime-dependency-in-the-pac.patch} \"$sourceRoot\"/0002-add-ppx_sexp_conv-as-a-runtime-dependency-in-the-pac.patch\nln -sv ${./0001-add-missing-runtime-dependencies-in-_tags.patch} \"$sourceRoot\"/0001-add-missing-runtime-dependencies-in-_tags.patch";
  buildInputs = [
    ocaml findlib ocamlbuild topkg cpuid ocb-stubblr ppx_deriving
    ppx_sexp_conv ]
  ++
  stdenv.lib.optional doCheck ounit
  ++
  [
    cstruct cstruct-lwt zarith lwt sexplib mirage-no-xen mirage-no-solo5 ];
  propagatedBuildInputs = [
    ocaml ppx_deriving ppx_sexp_conv ]
  ++
  stdenv.lib.optional doCheck ounit
  ++
  [
    cstruct cstruct-lwt zarith lwt sexplib mirage-no-xen mirage-no-solo5 ];
  configurePhase = "true";
  patches = [
    "0001-add-missing-runtime-dependencies-in-_tags.patch"
    "0002-add-ppx_sexp_conv-as-a-runtime-dependency-in-the-pac.patch"
    "0003-Auto-detect-ppx_sexp_conv-runtime-library.patch"
    "0004-pack-package-workaround-ocamlbuild-272.patch" ];
  buildPhase = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ")
  [
    [
      "'ocaml'" "'pkg/pkg.ml'" "'build'" "'--pinned'" "false" "'--tests'"
      "'false'" "'--jobs'" "'1'" "'--with-lwt'"
      "${if lwt != null then "true" else "false"}" "'--xen'" "false" "'--freestanding'" "false"
    ]
  ];
  preInstall = stdenv.lib.concatMapStringsSep "\n" (stdenv.lib.concatStringsSep " ") [ ];
  installPhase = "runHook preInstall; mkdir -p $out; for i in *.install; do ${opam.installer}/bin/opam-installer -i --prefix=$out --libdir=$OCAMLFIND_DESTDIR \"$i\"; done";
  createFindlibDestdir = true;
}
