{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.02.3";
assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion jbuilder) "1.0+beta10";

stdenv.mkDerivation rec {
  pname = "re";
  name = "ocaml-${pname}-${version}";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "ocaml-re";
    rev = "${version}";
    sha256 = "1pb6w9wqg6gzcfaaw6ckv1bqjgjpmrzzqz7r0mp9w16qbf3i54zr";
  };

  buildInputs = [ ocaml findlib jbuilder ];

  propagatedBuildInputs = [ ];

  buildPhase = "jbuilder build -p ${pname}";

  inherit (jbuilder) installPhase;

  createFindLibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/ocaml/ocaml-re;
    description = "RE is a regular expression library for OCaml";
    license = licenses.lgpl2;
    platforms = ocaml.meta.platforms or [];
    # maintainers = [ maintainers.eqyiel ];
  };
}
