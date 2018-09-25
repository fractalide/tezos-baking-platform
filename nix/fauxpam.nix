{ stdenv }:
stdenv.mkDerivation {
  name = "fauxpam";
  src = (import <nixpkgs> {}).runCommand "empty" {} "mkdir $out";
  buildPhase = "cp ${./fauxpam.sh} ./fauxpam.sh";
  installPhase = "install -D fauxpam.sh $out/bin/opam";
}
