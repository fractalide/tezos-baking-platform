{ pkgs ? import ((import <nixpkgs> {}).fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "8f374ba6312f0204119fe71f321664fd8752a133";
    sha256 = "0qa8k81vlkkad2jd9jw8w50pss1jzw03vj6yz8x856ndiqc7zhg9";
  }) {}
}:

rec {
  inherit pkgs;
  inherit (pkgs) lib;
  opam2nixSrc = builtins.path { path = ./opam2nix; filter = path: type: baseNameOf path != ".git"; };
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

  onSelection = f: { self, super }: {
    selection = super.selection //
      f { self = self.selection; super = super.selection; };
  };

  sourcePackages = [
    {
      name = "bip39";
      version = "dev";
      src = tezos/vendors/ocaml-bip39;
    }
    {
      name = "irmin-lmdb";
      version = "dev";
      src = tezos/vendors/irmin-lmdb;
      opamFile = tezos/vendors/irmin-lmdb/irmin-lmdb.opam;
    }
    {
      name = "lmdb";
      version = "dev";
      src = tezos/vendors/ocaml-lmdb;
      opamFile = tezos/vendors/ocaml-lmdb/lmdb.opam;
    }
    {
      name = "uecc";
      version = "dev";
      src = tezos/vendors/ocaml-uecc;
      opamFile = tezos/vendors/ocaml-uecc/uecc.opam;
    }
    {
      name = "hacl";
      version = "dev";
      src = tezos/vendors/ocaml-hacl;
      opamFile = tezos/vendors/ocaml-hacl/hacl.opam;
    }
    {
      name = "ocplib-json-typed";
      version = "dev";
      src = tezos/vendors/ocplib-json-typed/lib_json_typed;
    }
    {
      name = "ocplib-json-typed-bson";
      version = "dev";
      src = tezos/vendors/ocplib-json-typed/lib_json_typed_bson;
    }
    {
      name = "ocplib-resto";
      version = "dev";
      src = tezos/vendors/ocplib-resto/lib_resto;
    }
    {
      name = "ocplib-resto-cohttp";
      version = "0.0.0";
      src = tezos/vendors/ocplib-resto/lib_resto-cohttp;
    }
    {
      name = "ocplib-resto-directory";
      version = "dev";
      src = tezos/vendors/ocplib-resto/lib_resto-directory;
    }
    {
      name = "blake2";
      version = "dev";
      src = tezos/vendors/ocaml-blake2;
    }
    {
      name = "secp256k1";
      version = "0.1";
      src = tezos/vendors/ocaml-secp256k1;
    }
    {
      name = "ledgerwallet-tezos";
      version = "0.1";
      src = tezos/vendors/ocaml-ledger-wallet;
      opamFile = "ledgerwallet-tezos.opam";
    }
    {
      name = "ledgerwallet";
      version = "dev";
      src = tezos/vendors/ocaml-ledger-wallet;
      opamFile = "ledgerwallet.opam";
    }
    {
      name = "tezos-clic";
      version = "0.0.0";
      src = tezos/src/lib_clic;
    }
    {
      name = "tezos-client";
      version = "0.0.0";
      src = tezos/src/bin_client;
    }
    {
      name = "tezos-client-base";
      version = "0.0.0";
      src = tezos/src/lib_client_base;
    }
    {
      name = "tezos-client-base-unix";
      version = "0.0.0";
      src = tezos/src/lib_client_base_unix;
    }
    {
      name = "tezos-protocol-alpha";
      version = "0.0.0";
      src = tezos/src/proto_alpha/lib_protocol;
      opamFile = tezos/src/proto_alpha/lib_protocol/tezos-protocol-alpha.opam;
    }
    {
      name = "tezos-baking-alpha-commands";
      version = "0.0.0";
      src = tezos/src/proto_alpha/lib_baking;
      opamFile = tezos/src/proto_alpha/lib_baking/tezos-baking-alpha-commands.opam;
    }
    {
      name = "tezos-baking-alpha";
      version = "0.0.0";
      src = tezos/src/proto_alpha/lib_baking;
      opamFile = tezos/src/proto_alpha/lib_baking/tezos-baking-alpha.opam;
    }
    {
      name = "tezos-client-alpha";
      version = "0.0.0";
      src = tezos/src/proto_alpha/lib_client;
    }
    {
      name = "tezos-client-alpha-commands";
      version = "0.0.0";
      src = tezos/src/proto_alpha/lib_client_commands;
    }
    {
      name = "tezos-client-commands";
      version = "0.0.0";
      src = tezos/src/lib_client_commands;
    }
    {
      name = "tezos-client-genesis";
      version = "0.0.0";
      src = tezos/src/proto_genesis/lib_client;
    }
    {
      name = "tezos-node";
      version = "0.0.0";
      src = tezos/src/bin_node;
    }
    {
      name = "tezos-embedded-protocol-alpha";
      version = "0.0.0";
      src = tezos/src/proto_alpha/lib_protocol;
      opamFile = tezos/src/proto_alpha/lib_protocol/tezos-embedded-protocol-alpha.opam;
    }
    {
      name = "tezos-protocol-compiler";
      version = "0.0.0";
      src = tezos/src/lib_protocol_compiler;
    }
    {
      name = "tezos-protocol-updater";
      version = "0.0.0";
      src = tezos/src/lib_protocol_updater;
    }
    {
      name = "tezos-storage";
      version = "0.0.0";
      src = tezos/src/lib_storage;
    }
    {
      name = "tezos-stdlib-unix";
      version = "0.0.0";
      src = tezos/src/lib_stdlib_unix;
    }
    {
      name = "tezos-embedded-protocol-demo";
      version = "0.0.0";
      src = tezos/src/proto_demo/lib_protocol;
      opamFile = tezos/src/proto_demo/lib_protocol/tezos-embedded-protocol-demo.opam;
    }
    {
      name = "tezos-base";
      version = "0.0.0";
      src = tezos/src/lib_base;
    }
    {
      name = "tezos-crypto";
      version = "0.0.0";
      src = tezos/src/lib_crypto;
    }
    {
      name = "tezos-stdlib";
      version = "0.0.0";
      src = tezos/src/lib_stdlib;
    }
    {
      name = "tezos-shell";
      version = "0.0.0";
      src = tezos/src/lib_shell;
    }
    {
      name = "tezos-shell-services";
      version = "0.0.0";
      src = tezos/src/lib_shell_services;
    }
    {
      name = "tezos-micheline";
      version = "0.0.0";
      src = tezos/src/lib_micheline;
    }
    {
      name = "tezos-error-monad";
      version = "0.0.0";
      src = tezos/src/lib_error_monad;
    }
    {
      name = "tezos-data-encoding";
      version = "0.0.0";
      src = tezos/src/lib_data_encoding;
    }
    {
      name = "tezos-rpc";
      version = "0.0.0";
      src = tezos/src/lib_rpc;
    }
    {
      name = "tezos-rpc-http";
      version = "0.0.0";
      src = tezos/src/lib_rpc_http;
    }
    {
      name = "tezos-p2p";
      version = "0.0.0";
      src = tezos/src/lib_p2p;
    }
    {
      name = "tezos-protocol-environment";
      version = "0.0.0";
      src = tezos/src/lib_protocol_environment;
      opamFile = tezos/src/lib_protocol_environment/tezos-protocol-environment.opam;
    }
    {
      name = "tezos-protocol-environment-shell";
      version = "0.0.0";
      src = tezos/src/lib_protocol_environment;
      opamFile = tezos/src/lib_protocol_environment/tezos-protocol-environment-shell.opam;
    }
    {
      name = "tezos-protocol-genesis";
      version = "0.0.0";
      src = tezos/src/proto_genesis/lib_protocol;
      opamFile = tezos/src/proto_genesis/lib_protocol/tezos-protocol-genesis.opam;
    }
    {
      name = "tezos-embedded-protocol-genesis";
      version = "0.0.0";
      src = tezos/src/proto_genesis/lib_protocol;
      opamFile = tezos/src/proto_genesis/lib_protocol/tezos-embedded-protocol-genesis.opam;
    }
    {
      name = "tezos-protocol-environment-sigs";
      version = "0.0.0";
      src = tezos/src/lib_protocol_environment;
      opamFile = tezos/src/lib_protocol_environment/tezos-protocol-environment-sigs.opam;
    }
    {
      name = "tezos-baker-alpha";
      version = "0.0.0";
      src = tezos/src/proto_alpha/bin_baker;
    }
    {
      name = "tezos-signer-backends";
      version = "0.0.0";
      src = tezos/src/lib_signer_backends;
      opamFile = tezos/src/lib_signer_backends/tezos-signer-backends.opam;
    }
    {
      name = "tezos-signer-services";
      version = "0.0.0";
      src = tezos/src/lib_signer_services;
      opamFile = tezos/src/lib_signer_services/tezos-signer-services.opam;
    }
    {
      name = "tezos-client-alpha-services";
      version = "0.0.0";
      src = tezos/src/proto_alpha/lib_client_services;
      opamFile = tezos/src/proto_alpha/lib_client_services/tezos-client-alpha-services.opam;
    }
  ];

  opamSolution = opam2nix.buildOpamPackages sourcePackages {
    ocamlAttr = "ocamlPackages_latest.ocaml";
    specs = [
      { name = "jbuilder"; constraint = "=1.0+beta20"; }
      { name = "ocb-stubblr"; }
      { name = "cpuid"; }
    ];
    select = (onSelection ({ self, super }: {
      leveldb = addBuildInputs super.leveldb [ pkgs.snappy ];
      ocplib-resto-cohttp = addBuildInputs super.ocplib-resto-cohttp [self.jbuilder self.lwt self.ocplib-resto self.ocplib-resto-directory];
      ocplib-resto-directory = addBuildInputs super.ocplib-resto-directory [self.jbuilder self.lwt self.ocplib-resto];
      tezos-rpc-http = addBuildInputs super.tezos-rpc-http [self.ocplib-resto-cohttp];
      cpuid = addBuildInputs super.cpuid [ fauxpam ];
      nocrypto = addBuildInputs super.nocrypto [ fauxpam ];
      tezos-node = addBuildInputs super.tezos-node [ pkgs.snappy ];
      hidapi = addBuildInputs super.hidapi [ pkgs.pkgconfig pkgs.hidapi ];
      num = super.num.overrideAttrs (drv: { buildPhase = ''
        ${drv.buildPhase}
        set -x
        sed -Ei 's#^install:#insplode:#' src/Makefile
        sed -Ei 's#^findlib-install:#install:#' src/Makefile
      ''; });
    }));
  };
  node = opamSolution.packages.tezos-node;
  client = opamSolution.packages.tezos-client;
  baker-alpha = opamSolution.packages.tezos-baker-alpha;

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
      node
      client
      baker-alpha
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
    nativeBuildInputs = [pkgs.psmisc pkgs.jq node client];
    buildInputs = [pkgs.bash node client baker-alpha tezos-loadtest];
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
        ${node}/bin/tezos-node config init "''${node_args[@]}"
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

        $out/bin/tezos-sandbox-client.sh bootstrapped
        for i in "\''${!bootstrap_secrets[@]}" ; do
          $out/bin/tezos-sandbox-client.sh import secret key bootstrap\$i unencrypted:"\''${bootstrap_secrets[i]}"
        done

        $out/bin/tezos-sandbox-client.sh import secret key dictator "unencrypted:edsk31vznjHSSpGExDMHYASz45VZqXN4DPxvsa4hAyY8dHM28cZzp6"
        cp $out/protocol_parameters.json "${datadir}"
      EOF_BOOTSTRAP

      cat > $out/bin/bootstrap-alphanet.sh <<EOF_ALPHANET
      #/usr/bin/env bash
        $out/bin/tezos-sandbox-client.sh \
            -block genesis \
            bootstrapped
        $out/bin/tezos-sandbox-client.sh \
            -block genesis \
            activate protocol ProtoALphaALphaALphaALphaALphaALphaALphaALphaDdp3zK \
            with fitness ${expected_pow} \
            and key dictator \
            and parameters ${datadir}/protocol_parameters.json

        # TODO: This should not be neccessary; the daemon should be able to bake block 1...
        FIRST_BAKER="\$($out/bin/tezos-sandbox-client.sh rpc get /chains/main/blocks/head/helpers/baking_rights | jq '.[0].delegate' -r)"
        echo "Waiting for first baking opportunity"
        sleep $(( 2 * $(jq '.[0]' -r <<< '${time_between_blocks}') ))
        $out/bin/tezos-sandbox-client.sh -l \
            bake for "\$FIRST_BAKER"
      EOF_ALPHANET

      # create wrapper around client programs, setting arguments for working
      # within the sandbox.  programs will connect to peer 1 but can be given
      # CLI flags to do otherwise, as the normal client programs already do.
      cat > $out/bin/tezos-sandbox-client.sh <<EOF_CLIENT
      #!/usr/bin/env bash
      set -ex
      exec ${client}/bin/tezos-client "--config-file" "$out/client/config" "\$@"
      EOF_CLIENT

      # create a wrapper around tezos-node setting arguments for working within the sandbox
      cat > $out/bin/tezos-sandbox-node.sh <<EOF_NODE
      #!/usr/bin/env bash
      set -xe ; nodeid="\$1" ; shift

      node_args=("--config-file=$out/node-\$nodeid/config.json")

      mkdir -p "${datadir}/node-\$nodeid"
      if [ ! -f "${datadir}/node-\$nodeid/identity.json" ] ; then
        ${node}/bin/tezos-node identity generate ${expected_pow} "\''${node_args[@]}"
      fi

      # logfile is already redirected by config
      if [ "\$1" == "run" ] ; then
        node_args=("\''${node_args[@]}" "--sandbox=$out/sandbox.json")
        for peerid in \$(seq 1 ${max_peer_id}) ; do
          node_args=("\''${node_args[@]}" "--peer=127.0.0.1:\$((19730 + peerid))")
        done
      fi;

      exec ${node}/bin/tezos-node "\$@" "\''${node_args[@]}"
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
        ${node}/bin/tezos-node identity generate ${expected_pow} "\''${node_args[@]}"
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

      exec ${node}/bin/tezos-node "\$@" "\''${node_args[@]}"
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
        $out/bin/tezos-sandbox-client.sh launch daemon bootstrap\$bootstrapid -B -E -D -M --monitor-port \$((17730+\$bootstrapid)) >${datadir}/clientd-bootstrap\$bootstrapid.log 2>&1 &
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

      until $out/bin/tezos-sandbox-client.sh bootstrapped 2>/dev/null ; do
        echo -n .
        sleep 1
      done

      $out/bin/bootstrap-env.sh
      $out/bin/bootstrap-alphanet.sh
      EOF_FULLBOOT


      cat > $out/bin/monitored-bakers.sh << EOF_MONITBAKER
      #!/usr/bin/env bash
      set -eux

      for i in \$(seq 1 "\$#") ; do
          echo "LAUNCH BAKER:" "\''${!i}"
          $out/bin/tezos-sandbox-client.sh -A 127.0.0.1 -P \$(((i - 1) % ${max_peer_id} + 18731)) launch daemon "\''${!i}" -B -E -D -M --monitor-port \$((17730+\$i)) >${datadir}/clientd-bootstrap\$i.log 2>&1 & pid=\$!
          sleep 1
          if ! kill -0 \$pid; then
              echo >&2 "Problem launching tezos-bake-monitor: \$pid"
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
        blockhead="\$(tezos-sandbox-client.sh rpc call /blocks/head with '{}' 2>/dev/null)"
        blockhead_ok=\$?
        if [ \$blockhead_ok -eq 0 -a 3 -le "\$(jq '.level' <<< "\$blockhead")" ] ; then
          break
        else
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
