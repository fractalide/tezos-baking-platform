{ stdenv }:
stdenv.mkDerivation {
  name = "fauxpam";
  src = /var/empty;
  buildPhase = "cp ${./fauxpam.sh} ./fauxpam.sh";
  installPhase = "install -D fauxpam.sh $out/bin/opam";
}
