{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.03.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder) "1.0+beta19.1";

stdenv.mkDerivation rec {
  pname = "bigstring";
  name = "ocaml-${pname}-${version}";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-bigstring";
    rev = "${version}";
    sha256 = "0ypdf29cmwmjm3djr5ygz8ls81dl41a4iz1xx5gbcdpbrdiapb77";
  };

  buildInputs = [ ocaml findlib jbuilder ];

  buildPhase = "jbuilder build -p bigstring @install";

  inherit (jbuilder) installPhase;

  createFindLibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/c-cube/ocaml-bigstring/;
    description = "A set of utils for dealing with bigarrays of char as if they were proper OCaml strings.";
    license = licenses.bsd2;
    platforms = ocaml.meta.platforms or [];
    # maintainers = [ maintainers.eqyiel ];
  };
}
