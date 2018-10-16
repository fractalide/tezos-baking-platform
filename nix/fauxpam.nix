{ stdenv }:
stdenv.mkDerivation {
  name = "fauxpam";
  src = (import <nixpkgs> {}).runCommand "empty" { outputHashMode = "recursive"; outputHashAlgo = "sha256"; outputHash = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5"; } "mkdir $out";
  buildPhase = "cp ${./fauxpam.sh} ./fauxpam.sh";
  installPhase = "install -D fauxpam.sh $out/bin/opam";
}
