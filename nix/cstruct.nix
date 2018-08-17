{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder, sexplib }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.03.0";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder) "1.0+beta10";

stdenv.mkDerivation rec {
  pname = "cstruct";
  name = "ocaml-${pname}-${version}";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "ocaml-cstruct";
    rev = "v${version}";
    sha256 = "1pz3nbr6hhiqkwn5f3jbz84m479b36k8kb45jqqbxb1x2yf537rg";
  };

  buildInputs = [ ocaml findlib jbuilder sexplib ];

  propagatedBuildInputs = [ sexplib ];

  buildPhase = "jbuilder build -p ${pname}";

  inherit (jbuilder) installPhase;

  createFindLibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-cstruct;
    description = "Access C-like structures directly from OCaml";
    license = licenses.isc;
    platforms = ocaml.meta.platforms or [];
    # maintainers = [ maintainers.eqyiel ];
  };
}
