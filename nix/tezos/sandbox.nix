{ expected_pow ? "20" # Floating point number between 0 and 256 that represents a difficulty, 24 signifies for example that at least 24 leading zeroes are expected in the hash.
, data_dir ? "./sandbox"
, max_peer_id ? "9"
, expected_connections ? "3"
, time_between_blocks ? ''["5"]''
, tezos
, tezos-loadtest
, psmisc
, jq
, sandbox-env
# TODO: protocol parameters, especially time_between_blocks
 : pkgs.stdenv.mkDerivation {
  name = "tezos-sandbox-sandbox";
  src = null;
  doUnpack = false;
  phases = [ "buildPhase" ];
  buildPhase = "mkdir -p $out";
  nativeBuildInputs = [
    (sandbox-env {
      inherit expected_pow data_dir max_peer_id expected_connections time_between_blocks;
    })
    tezos
    tezos-loadtest
    psmisc
    jq
  ];
}
