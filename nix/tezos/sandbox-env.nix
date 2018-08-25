{ expected_pow # Floating point number between 0 and 256 that represents a difficulty, 24 signifies for example that at least 24 leading zeroes are expected in the hash.
, data_dir
, max_peer_id
, expected_connections
, time_between_blocks
, stdenv
, psmisc
, jq
, bash
, tezos
, tezos-src
, tezos-loadtest
} : stdenv.mkDerivation {
  name = "tezos-sandbox";
  sourceRoot = ".";
  srcs = [ (tezos-src + /scripts) tezos-loadtest.src ];

  configurePhase = "true";
  installPhase = "true";
  nativeBuildInputs = [psmisc jq tezos];
  buildInputs = [bash tezos-loadtest];
  buildPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/client

    cp ./scripts/sandbox.json $out
    cat < ./scripts/protocol_parameters.json \
      | jq '.time_between_blocks = $tbb' --argjson tbb '${time_between_blocks}' \
      > $out/protocol_parameters.json

    # TODO: Set traders/bakers/nodes
    cat < ./tezos-load-testing/config.json \
      | jq '._client_exe = $client' --arg client $out/bin/tezos-sandbox-client.sh \
      > $out/loadtest-config.json

    # generate node sandbox config
    for nodeid in $(seq 1 ${max_peer_id}) ; do
      mkdir -p "$out/node-$nodeid"

      declare -a node_args
      node_args=("--config-file=$out/node-$nodeid/config.json"
	  "--data-dir=${data_dir}/node-$nodeid"
	  "--rpc-addr=0.0.0.0:$((18730 + nodeid))"
	  "--net-addr=127.0.0.1:$((19730 + nodeid))"
	  "--expected-pow=${expected_pow}"
	  "--private-mode"
	  "--no-bootstrap-peers"
	  "--connections=${expected_connections}"
	  "--log-output=${data_dir}/node-$nodeid.log"
	  )
      for peerid in $(seq 1 ${max_peer_id}) ; do
	node_args=("''${node_args[@]}" "--peer=127.0.0.1:$((19730 + peerid))")
      done
      ${tezos}/bin/tezos-node config init "''${node_args[@]}"
    done

    cat > $out/bin/sandbox-env.inc.sh << EOF_ENVIRON
    SANDBOX_DATADIR="${data_dir}"
    SANDBOX_FILE=$out/sandbox.json
    PROTOCOL_PARAMETERS_FILE=$out/protocol_parameters.json
    EOF_ENVIRON

    # There is no clear way to get tezos-client to do this for us.
    cat > $out/client/config << EOF_CLIENTCONFIG
    {
      "base_dir": "${data_dir}/client",
      "node_addr": "127.0.0.1",
      "node_port": 18731,
      "tls": false,
      "web_port": 8080
    }
    EOF_CLIENTCONFIG

    cat > $out/bin/bootstrap-env.sh <<EOF_BOOTSTRAP
    #/usr/bin/env bash
      set -xe
      bootstrap_secrets=(
	"edsk3gUfUPyBSfrS9CCgmCiQsTCHGkviBDusMxDJstFtojtc1zcpsh"
	"edsk39qAm1fiMjgmPkw1EgQYkMzkJezLNewd7PLNHTkr6w9XA2zdfo"
	"edsk4ArLQgBTLWG5FJmnGnT689VKoqhXwmDPBuGx3z4cvwU9MmrPZZ"
	"edsk2uqQB9AY4FvioK2YMdfmyMrer5R8mGFyuaLLFfSRo8EoyNdht3"
	"edsk4QLrcijEffxV31gGdN2HU7UpyJjA8drFoNcmnB28n89YjPNRFm"
      )

      for i in "\''${!bootstrap_secrets[@]}" ; do
	$out/bin/tezos-sandbox-client.sh import secret key bootstrap\$i unencrypted:"\''${bootstrap_secrets[i]}"
      done

      $out/bin/tezos-sandbox-client.sh import secret key dictator "unencrypted:edsk31vznjHSSpGExDMHYASz45VZqXN4DPxvsa4hAyY8dHM28cZzp6"
      cp $out/protocol_parameters.json "${data_dir}"
    EOF_BOOTSTRAP

    cat > $out/bin/bootstrap-alphanet.sh <<EOF_ALPHANET
    #/usr/bin/env bash
      while ! $out/bin/tezos-sandbox-client.sh bootstrapped ; do
	  echo "waiting for network"
	  sleep 1
      done
      $out/bin/tezos-sandbox-client.sh \
	  -block genesis \
	  activate protocol PtCJ7pwoxe8JasnHY8YonnLYjcVHmhiARPJvqcC6VfHT5s8k8sY \
	  with fitness ${expected_pow} \
	  and key dictator \
	  and parameters ${data_dir}/protocol_parameters.json

      # TODO: This should not be neccessary; the daemon should be able to bake block 1...
      # FIRST_BAKER="\$($out/bin/tezos-sandbox-client.sh rpc get /chains/main/blocks/head/helpers/baking_rights | jq '.[0].delegate' -r)"
      # sleep $(( 2 * $(jq '.[0]' -r <<< '${time_between_blocks}') ))
      # $out/bin/tezos-sandbox-client.sh -l \
      #     bake for "\$FIRST_BAKER"
    EOF_ALPHANET

    # create wrapper around client programs, setting arguments for working
    # within the sandbox.  programs will connect to peer 1 but can be given
    # CLI flags to do otherwise, as the normal client programs already do.
    set -eux
    declare -a utilities
    declare -a nix_paths
    utilities=(baker-alpha endorser-alpha signer accuser-alpha client)
    nix_paths=(${tezos})
    for i in "''${!utilities[@]}"; do
	utility="''${utilities[$i]}"
	nix_path="''${nix_paths[$i]}"
	cat > $out/bin/tezos-sandbox-$utility.sh <<EOF_CLIENT
    #!/usr/bin/env bash
    set -ex
    exec "$nix_path"/bin/tezos-$utility "--config-file" "$out/client/config" "\$@"
    EOF_CLIENT
    done
    set +x

    # create a wrapper around tezos-node setting arguments for working within the sandbox
    cat > $out/bin/tezos-sandbox-node.sh <<EOF_NODE
    #!/usr/bin/env bash
    set -xe ; nodeid="\$1" ; shift

    node_args=("--config-file=$out/node-\$nodeid/config.json")

    mkdir -p "${data_dir}/node-\$nodeid"
    if [ ! -f "${data_dir}/node-\$nodeid/identity.json" ] ; then
      ${tezos}/bin/tezos-node identity generate ${expected_pow} "\''${node_args[@]}"
    fi

    # logfile is already redirected by config
    if [ "\$1" == "run" ] ; then
      node_args=("\''${node_args[@]}" "--sandbox=$out/sandbox.json")
      for peerid in \$(seq 1 ${max_peer_id}) ; do
	node_args=("\''${node_args[@]}" "--peer=127.0.0.1:\$((19730 + peerid))")
      done
    fi;

    exec ${tezos}/bin/tezos-node "\$@" "\''${node_args[@]}"
    EOF_NODE

    # as above, but creates a fragile network where the loss of peer 1 causes a split-brain situation.
    # theory: a=b=c-d-e=f=g will not lead to a fork, but removing d, having
    #         a=b=c   e=f=g should produce a fork.

    # sketch:
    # - create a network that looks like: a=b=c-d-e=f=g
    # - bake on both sides of the brittle connection
    # - break the brittle connection
    # - bake on both hemispheres of the split-brain
    # - observe height on diverted forks.
    cat > $out/bin/tezos-sandbox-fragile-node.sh <<EOF_FRAGILENODE
    #!/usr/bin/env bash
    set -xe ; nodeid="\$1" ; shift

    node_args=("--config-file=$out/node-\$nodeid/config.json")

    mkdir -p "$out/node-$nodeid"
    if [ ! -f "${data_dir}/node-\$nodeid/identity.json" ] ; then
      ${tezos}/bin/tezos-node identity generate ${expected_pow} "\''${node_args[@]}"
    fi

    left_hemisphere=($(seq 2 2 ${max_peer_id}) )
    right_hemisphere=($(seq 3 2 ${max_peer_id}) )
    left_peers=( \''${left_hemisphere[@]} 1 )
    right_peers=( \''${right_hemisphere[@]} 1)
    fragile_peers=( \$(seq 1 $(( ${max_peer_id} / 2 ))))

    # logfile is already redirected by config
    if [ "\$1" == "run" ] ; then
      node_args=("\''${node_args[@]}" "--sandbox=$out/sandbox.json" "--closed" "--no-bootstrap-peers")
      if [ "\$nodeid" -eq 1 ] ; then
	node_args=("\''${node_args[@]}" \$(printf -- "--peer=127.0.0.1:%s\n" \$(for i in "\''${fragile_peers[@]}" ; do echo \$((19730 + i)) ; done)))
      elif [ \$(( "\$nodeid" % 2 )) -eq 0 ] ; then
	node_args=("\''${node_args[@]}" \$(printf -- "--peer=127.0.0.1:%s\n" \$(for i in "\''${left_peers[@]}" ; do echo \$((19730 + i)) ; done)))
      else
	node_args=("\''${node_args[@]}" \$(printf -- "--peer=127.0.0.1:%s\n" \$(for i in "\''${right_peers[@]}" ; do echo \$((19730 + i)) ; done)))
      fi
    fi

    exec ${tezos}/bin/tezos-node "\$@" "\''${node_args[@]}"
    EOF_FRAGILENODE


    cat > $out/bin/tezos-sandbox-network.sh <<EOF_NETWORK
    #!/usr/bin/env bash
    set -ex
    dflt_node_exe="$out/bin/tezos-sandbox-node.sh"
    node_exe="\''${NODE_EXE:-\$dflt_node_exe}"
    for nodeid in \$(seq 1 ${max_peer_id}) ; do
      \$node_exe \$nodeid run &
    done
    EOF_NETWORK

    cat > $out/bin/bootstrap-baking.sh << EOF_BOOTBAKE
    #!/usr/bin/env bash
    set -ex
    for bootstrapid in \$(seq 1 "\''${1:-3}") ; do
      $out/bin/tezos-sandbox-baker-alpha.sh run with local node "${data_dir}/node-\$bootstrapid" bootstrap\$bootstrapid >${data_dir}/clientd-bootstrap\$bootstrapid.log 2>&1 &
      $out/bin/tezos-sandbox-endorser-alpha.sh run bootstrap\$bootstrapid >${data_dir}/clientd-bootstrap\$bootstrapid.log 2>&1 &
      # We would run an accuser, but we are not economically motivated to.
    done
    EOF_BOOTBAKE

    cat > $out/bin/tezos-sandbox-bootstrap.sh <<EOF_FULLBOOT
    #!/usr/bin/env bash
    set -ex
    mkdir -p ${data_dir}
    if [ ! -f "${data_dir}/loadtest-config.json" ] ; then
      cp $out/loadtest-config.json "${data_dir}/loadtest-config.json"
      chmod 644 "${data_dir}/loadtest-config.json"
    fi

    $out/bin/tezos-sandbox-network.sh

    $out/bin/bootstrap-env.sh
    $out/bin/bootstrap-alphanet.sh
    EOF_FULLBOOT

    cat > $out/bin/monitored-bakers.sh << EOF_MONITBAKER
    #!/usr/bin/env bash
    set -eux

    for i in \$(seq 1 "\$#") ; do
	echo "LAUNCH BAKER:" "\''${!i}"

	# TODO ADD THIS BACK WHEN !424 is merged
	# -M --monitor-port \$((17730+\$i))
	$out/bin/tezos-sandbox-baker-alpha.sh -A 127.0.0.1 -P \$(((i - 1) % ${max_peer_id} + 18731)) run with local node "${data_dir}/node-\$i" "\''${!i}" >${data_dir}/clientd-bootstrap\$i.log 2>&1 & pid=\$!
	sleep 1
	if ! kill -0 \$pid; then
	    echo >&2 "Problem launching baker: \$pid"
	    false
	fi

	$out/bin/tezos-sandbox-endorser-alpha.sh -A 127.0.0.1 -P \$(((i - 1) % ${max_peer_id} + 18731)) run "\''${!i}" >${data_dir}/clientd-bootstrap\$i.log 2>&1 & pid=\$!
	sleep 1
	if ! kill -0 \$pid; then
	    echo >&2 "Problem launching endorser: \$pid"
	    false
	fi
    done
    EOF_MONITBAKER

    cat > $out/bin/tezos-sandbox-theworks.sh <<EOF_THEWORKS
    #!/usr/bin/env bash
    set -ex
    $out/bin/tezos-sandbox-bootstrap.sh

    # Run 3 of 5 bakers so that sandbox users can start the others manually if needed
    $out/bin/monitored-bakers.sh bootstrap0 bootstrap1 bootstrap2

    # don't start the load test until some progress has been made by the bootstrap bakers.
    while true ; do
      blockhead="\$(tezos-sandbox-client.sh rpc get /chains/main/blocks/head 2>/dev/null)"
      blockhead_ok=\$?
      if [ \$blockhead_ok -eq 0 -a 3 -le "\$(jq '.header.level' <<< "\$blockhead")" ] ; then
	break
      else
	echo "waiting for progress"
	sleep 1
      fi
    done

    # echo "Generating transactions.  (press ^C at any time)"
    ${tezos-loadtest}/bin/tezos-loadtest "${data_dir}/loadtest-config.json"
    EOF_THEWORKS

    chmod +x $out/bin/*.sh
  '';
}
