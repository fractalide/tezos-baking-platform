{ pkgs ? import nix/nixpkgs.nix {}
}:
rec {
  inherit pkgs;
  inherit (pkgs) lib;
  opam2nixSrc = builtins.filterSource (path: type: baseNameOf path != ".git") ./opam2nix;
  opam2nixBin = (pkgs.callPackage "${opam2nixSrc}/nix" { inherit pkgs; }).overrideAttrs (drv: { src = opam2nixSrc; });
  opam2nix = pkgs.callPackage opam2nix-packages/nix { inherit pkgs opam2nixBin ; };

  addBuildInputs = p: buildInputs: lib.overrideDerivation p (attrs: {
    buildInputs = (attrs.buildInputs or []) ++ buildInputs;
  });

  fauxpam = pkgs.runCommand "fauxpam" {} ''
    mkdir -p "$out/bin"
    cat >"$out/bin/opam" <<'EOF'
    #!/bin/sh
    echo "$@"
    EOF
    chmod +x "$out/bin/opam"
  ''; # (extremely) fake opam executable that packages can use when requesting certain opam configs that may be blank

  tezosWorld = pkgs.callPackage nix/tezos/world {};

  tezos = tezosWorld.callPackage nix/tezos.nix {};

  tezos-opam-sandbox = pkgs.stdenv.mkDerivation {
    name = "tezos-opam-sandbox";
    src = null;
    doUnpack = false;
    phases = [ "buildPhase" ];
    buildPhase = "mkdir -p $out";
    nativeBuildInputs = [
      (pkgs.ocaml-ng.ocamlPackages_4_06.callPackage nix/opam2.nix {})
      pkgs.ocaml-ng.ocamlPackages_4_06.ocaml
      pkgs.bubblewrap
      pkgs.curl
      pkgs.git
      pkgs.gmp
      pkgs.hidapi
      pkgs.libev
      pkgs.m4
      pkgs.rsync
      pkgs.perl
      pkgs.pkgconfig
      pkgs.unzip
      pkgs.which
    ];
  };


  sandbox =
      { expected_pow ? "20" # Floating point number between 0 and 256 that represents a difficulty, 24 signifies for example that at least 24 leading zeroes are expected in the hash.
      , datadir ? "./sandbox"
      , max_peer_id ? "9"
      , expected_connections ? "3"
      , time_between_blocks ? ''["5"]''
      # TODO: protocol parameters, especially time_between_blocks
  } : pkgs.stdenv.mkDerivation {
    name = "tezos-sandbox-sandbox";
    src = null;
    doUnpack = false;
    phases = [ "buildPhase" ];
    buildPhase = "mkdir -p $out";
    nativeBuildInputs = [
      (sandbox-env {
        inherit expected_pow datadir max_peer_id expected_connections time_between_blocks;
      })
      tezos
      tezos-loadtest
      pkgs.psmisc
      pkgs.jq
    ];
  };

  sandbox-env =
      { expected_pow # Floating point number between 0 and 256 that represents a difficulty, 24 signifies for example that at least 24 leading zeroes are expected in the hash.
      , datadir
      , max_peer_id
      , expected_connections
      , time_between_blocks
  } : pkgs.stdenv.mkDerivation {
    name = "tezos-sandbox";
    # src = lib.sourceByRegex ./. ["tezos.scripts.*" "tezos-loadtest.*"];
    sourceRoot = ".";
    srcs = [./tezos/scripts  ./tezos-load-testing ];

    configurePhase = "true";
    installPhase = "true";
    nativeBuildInputs = [pkgs.psmisc pkgs.jq tezos];
    buildInputs = [pkgs.bash tezos-loadtest];
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
            "--data-dir=${datadir}/node-$nodeid"
            "--rpc-addr=0.0.0.0:$((18730 + nodeid))"
            "--net-addr=127.0.0.1:$((19730 + nodeid))"
            "--expected-pow=${expected_pow}"
            "--private-mode"
            "--no-bootstrap-peers"
            "--connections=${expected_connections}"
            "--log-output=${datadir}/node-$nodeid.log"
            )
        for peerid in $(seq 1 ${max_peer_id}) ; do
          node_args=("''${node_args[@]}" "--peer=127.0.0.1:$((19730 + peerid))")
        done
        ${tezos}/bin/tezos-node config init "''${node_args[@]}"
      done

      cat > $out/bin/sandbox-env.inc.sh << EOF_ENVIRON
      SANDBOX_DATADIR="${datadir}"
      SANDBOX_FILE=$out/sandbox.json
      PROTOCOL_PARAMETERS_FILE=$out/protocol_parameters.json
      EOF_ENVIRON

      # There is no clear way to get tezos-client to do this for us.
      cat > $out/client/config << EOF_CLIENTCONFIG
      {
        "base_dir": "${datadir}/client",
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
        cp $out/protocol_parameters.json "${datadir}"
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
            and parameters ${datadir}/protocol_parameters.json

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

      mkdir -p "${datadir}/node-\$nodeid"
      if [ ! -f "${datadir}/node-\$nodeid/identity.json" ] ; then
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
      if [ ! -f "${datadir}/node-\$nodeid/identity.json" ] ; then
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
        $out/bin/tezos-sandbox-baker-alpha.sh run with local node "${datadir}/node-\$bootstrapid" bootstrap\$bootstrapid >${datadir}/clientd-bootstrap\$bootstrapid.log 2>&1 &
        $out/bin/tezos-sandbox-endorser-alpha.sh run bootstrap\$bootstrapid >${datadir}/clientd-bootstrap\$bootstrapid.log 2>&1 &
        # We would run an accuser, but we are not economically motivated to.
      done
      EOF_BOOTBAKE

      cat > $out/bin/tezos-sandbox-bootstrap.sh <<EOF_FULLBOOT
      #!/usr/bin/env bash
      set -ex
      mkdir -p ${datadir}
      if [ ! -f "${datadir}/loadtest-config.json" ] ; then
        cp $out/loadtest-config.json "${datadir}/loadtest-config.json"
        chmod 644 "${datadir}/loadtest-config.json"
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
          $out/bin/tezos-sandbox-baker-alpha.sh -A 127.0.0.1 -P \$(((i - 1) % ${max_peer_id} + 18731)) run with local node "${datadir}/node-\$i" "\''${!i}" >${datadir}/clientd-bootstrap\$i.log 2>&1 & pid=\$!
          sleep 1
          if ! kill -0 \$pid; then
              echo >&2 "Problem launching baker: \$pid"
              false
          fi

          $out/bin/tezos-sandbox-endorser-alpha.sh -A 127.0.0.1 -P \$(((i - 1) % ${max_peer_id} + 18731)) run "\''${!i}" >${datadir}/clientd-bootstrap\$i.log 2>&1 & pid=\$!
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
      ${tezos-loadtest}/bin/tezos-loadtest "${datadir}/loadtest-config.json"
      EOF_THEWORKS

      chmod +x $out/bin/*.sh
    '';
  };

  tezos-bake-monitor = pkgs.callPackage ./tezos-bake-monitor/tezos-bake-monitor {
    inherit pkgs;
  };

  tezos-loadtest = pkgs.callPackage ./tezos-load-testing {
    inherit pkgs;
  };

  tezos-bake-central = (import ./tezos-bake-monitor/tezos-bake-central {}).exe;

  bake-central-docker = let
    bakeCentralSetupScript = pkgs.dockerTools.shellScript "dockersetup.sh" ''
      set -ex

      ${pkgs.dockerTools.shadowSetup}
      echo 'nobody:x:99:99:Nobody:/:/sbin/nologin' >> /etc/passwd
      echo 'nobody:*:17416:0:99999:7:::'           >> /etc/shadow
      echo 'nobody:x:99:'                          >> /etc/group
      echo 'nobody:::'                             >> /etc/gshadow

      mkdir -p    /var/run/bake-monitor
      chown 99:99 /var/run/bake-monitor
    '';
    bakeCentralEntrypoint = pkgs.dockerTools.shellScript "entrypoint.sh" ''
      set -ex

      mkdir -p /var/run/bake-monitor
      ln -sft /var/run/bake-monitor '${tezos-bake-central}'/*
      rm /var/run/bake-monitor/config
      mkdir -p /var/run/bake-monitor/config

      cd /var/run/bake-monitor
      exec ./backend "$@"
    '';
  in pkgs.dockerTools.buildImage {
    name = "tezos-bake-monitor";
    runAsRoot = bakeCentralSetupScript;
    keepContentsDirlinks = true;
    config = {
      Expose = 8000;
      Entrypoint = [bakeCentralEntrypoint];
      User = "99:99";
    };
  };
}
