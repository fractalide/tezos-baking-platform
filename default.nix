{ pkgs ?  import ((import <nixpkgs> {}).fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "b6ddb9913f2b8206837e0f137db907bdefb9275e";
    sha256 = "1yjbd5jhjgirv7ki0sms1x13dqyjzg0rpb7n67m6ik61fmpq0nfw";
  }) {}
}:

rec {
  o = pkgs.ocamlPackages_latest;
  inherit pkgs;
  inherit (pkgs) lib;
  opam2nix = pkgs.callPackage ./opam2nix-packages.nix { inherit pkgs; };

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

  onOpamSelection = f: { self, super }:
    { 
      opamSelection = super.opamSelection //
        f { self = self.opamSelection; super = super.opamSelection; };
    }; 

  opamSolution = opam2nix.buildOpamPackages {
    ocamlAttr = "ocamlPackages_latest.ocaml";
    specs = [
      { name = "jbuilder"; constraint = "=1.0+beta19.1"; }
      { name = "ocb-stubblr"; }
      { name = "cpuid"; }
    ];
    packagesParsed = [
      {
        packageName = "bip39";
        version = "dev";
        src = tezos/vendors/ocaml-bip39;
      }
      {
        packageName = "ocplib-resto";
        version = "dev";
        src = tezos/vendors/ocplib-resto/lib_resto;
      }
      {
        packageName = "ocplib-resto-cohttp";
        version = "0.0.0";
        src = tezos/vendors/ocplib-resto/lib_resto-cohttp;
      }
      {
        packageName = "ocplib-resto-directory";
        version = "dev";
        src = tezos/vendors/ocplib-resto/lib_resto-directory;
      }
      {
        packageName = "hacl";
        version = "dev";
        src = tezos/vendors/ocaml-hacl;
      }
      {
        packageName = "ocplib-json-typed-bson";
        version = "dev";
        src = tezos/vendors/ocplib-json-typed/lib_json_typed_bson;
      }
      {
        packageName = "ocplib-json-typed";
        version = "0.6";
        src = tezos/vendors/ocplib-json-typed/lib_json_typed;
      }
      {
        packageName = "blake2";
        version = "dev";
        src = tezos/vendors/ocaml-blake2;
      }
      {
        packageName = "irmin-leveldb";
        version = "0.0.0";
        src = tezos/vendors/irmin-leveldb;
      }
      {
        packageName = "secp256k1";
        version = "0.1";
        src = tezos/vendors/ocaml-secp256k1;
      }
      {
        packageName = "ledgerwallet-tezos";
        version = "dev";
        src = tezos/vendors/ocaml-ledger-wallet;
        opamFile = "ledgerwallet-tezos.opam";
      }
      {
        packageName = "ledgerwallet";
        version = "dev";
        src = tezos/vendors/ocaml-ledger-wallet;
        opamFile = "ledgerwallet.opam";
      }

      {
        packageName = "hidapi";
        version = "dev";
        # src = tezos/vendors/ocaml-hidapi;
        src = pkgs.fetchgit {
          url= "https://github.com/ryantrinkle/ocaml-hidapi";
          rev= "6d232b19e68a265acbb25d6194caa937cd64ba1f";
          sha256= "017cnl6w6bggcc3db697xprr881gp3fnrl913mp6dvrns46gj2pa";
          fetchSubmodules= true;
        };
      }
      {
        packageName = "tezos-clic";
        version = "0.0.0";
        src = tezos/src/lib_clic;
      }
      {
        packageName = "tezos-client";
        version = "0.0.0";
        src = tezos/src/bin_client;
      }
      {
        packageName = "tezos-client-base";
        version = "0.0.0";
        src = tezos/src/lib_client_base;
      }
      {
        packageName = "tezos-client-base-unix";
        version = "0.0.0";
        src = tezos/src/lib_client_base_unix;
      }
      {
        packageName = "tezos-protocol-alpha";
        version = "0.0.0";
        src = tezos/src/proto_alpha/lib_protocol;
        opamFile = tezos/src/proto_alpha/lib_protocol/tezos-protocol-alpha.opam;
      }
      {
        packageName = "tezos-baking-alpha-commands";
        version = "0.0.0";
        src = tezos/src/proto_alpha/lib_baking;
        opamFile = tezos/src/proto_alpha/lib_baking/tezos-baking-alpha-commands.opam;
      }
      {
        packageName = "tezos-baking-alpha";
        version = "0.0.0";
        src = tezos/src/proto_alpha/lib_baking;
        opamFile = tezos/src/proto_alpha/lib_baking/tezos-baking-alpha.opam;
      }
      {
        packageName = "tezos-client-alpha";
        version = "0.0.0";
        src = tezos/src/proto_alpha/lib_client;
      }
      {
        packageName = "tezos-client-alpha-commands";
        version = "0.0.0";
        src = tezos/src/proto_alpha/lib_client_commands;
      }
      {
        packageName = "tezos-client-commands";
        version = "0.0.0";
        src = tezos/src/lib_client_commands;
      }
      {
        packageName = "tezos-client-genesis";
        version = "0.0.0";
        src = tezos/src/proto_genesis/lib_client;
      }
      {
        packageName = "tezos-node";
        version = "0.0.0";
        src = tezos/src/bin_node;
      }
      {
        packageName = "tezos-embedded-protocol-alpha";
        version = "0.0.0";
        src = tezos/src/proto_alpha/lib_protocol;
        opamFile = tezos/src/proto_alpha/lib_protocol/tezos-embedded-protocol-alpha.opam;
      }
      {
        packageName = "tezos-protocol-compiler";
        version = "0.0.0";
        src = tezos/src/lib_protocol_compiler;
      }
      {
        packageName = "tezos-protocol-updater";
        version = "0.0.0";
        src = tezos/src/lib_protocol_updater;
      }
      {
        packageName = "tezos-storage";
        version = "0.0.0";
        src = tezos/src/lib_storage;
      }
      {
        packageName = "tezos-stdlib-unix";
        version = "0.0.0";
        src = tezos/src/lib_stdlib_unix;
      }
      {
        packageName = "tezos-embedded-protocol-demo";
        version = "0.0.0";
        src = tezos/src/proto_demo/lib_protocol;
        opamFile = tezos/src/proto_demo/lib_protocol/tezos-embedded-protocol-demo.opam;
      }
      {
        packageName = "tezos-base";
        version = "0.0.0";
        src = tezos/src/lib_base;
      }
      {
        packageName = "tezos-crypto";
        version = "0.0.0";
        src = tezos/src/lib_crypto;
      }
      {
        packageName = "tezos-stdlib";
        version = "0.0.0";
        src = tezos/src/lib_stdlib;
      }
      {
        packageName = "tezos-shell";
        version = "0.0.0";
        src = tezos/src/lib_shell;
      }
      {
        packageName = "tezos-shell-services";
        version = "0.0.0";
        src = tezos/src/lib_shell_services;
      }
      {
        packageName = "tezos-micheline";
        version = "0.0.0";
        src = tezos/src/lib_micheline;
      }
      {
        packageName = "tezos-error-monad";
        version = "0.0.0";
        src = tezos/src/lib_error_monad;
      }
      {
        packageName = "tezos-data-encoding";
        version = "0.0.0";
        src = tezos/src/lib_data_encoding;
      }
      {
        packageName = "tezos-rpc";
        version = "0.0.0";
        src = tezos/src/lib_rpc;
      }
      {
        packageName = "tezos-rpc-http";
        version = "0.0.0";
        src = tezos/src/lib_rpc_http;
      }
      {
        packageName = "tezos-p2p";
        version = "0.0.0";
        src = tezos/src/lib_p2p;
      }
      {
        packageName = "tezos-protocol-environment";
        version = "0.0.0";
        src = tezos/src/lib_protocol_environment;
        opamFile = tezos/src/lib_protocol_environment/tezos-protocol-environment.opam;
      }
      {
        packageName = "tezos-protocol-environment-shell";
        version = "0.0.0";
        src = tezos/src/lib_protocol_environment;
        opamFile = tezos/src/lib_protocol_environment/tezos-protocol-environment-shell.opam;
      }
      {
        packageName = "tezos-protocol-genesis";
        version = "0.0.0";
        src = tezos/src/proto_genesis/lib_protocol;
        opamFile = tezos/src/proto_genesis/lib_protocol/tezos-protocol-genesis.opam;
      }
      {
        packageName = "tezos-embedded-protocol-genesis";
        version = "0.0.0";
        src = tezos/src/proto_genesis/lib_protocol;
        opamFile = tezos/src/proto_genesis/lib_protocol/tezos-embedded-protocol-genesis.opam;
      }
      {
        packageName = "tezos-protocol-environment-sigs";
        version = "0.0.0";
        src = tezos/src/lib_protocol_environment;
        opamFile = tezos/src/lib_protocol_environment/tezos-protocol-environment-sigs.opam;
      }
      {
        packageName = "tezos-baker-alpha";
        version = "0.0.0";
        src = tezos/src/proto_alpha/bin_baker;
      }
    ];
    overrides = onOpamSelection ({ self, super }: {
      leveldb = addBuildInputs super.leveldb [ pkgs.snappy ];
      ocplib-resto-cohttp = addBuildInputs super.ocplib-resto-cohttp [self.jbuilder self.lwt self.ocplib-resto self.ocplib-resto-directory];
      ocplib-resto-directory = addBuildInputs super.ocplib-resto-directory [self.jbuilder self.lwt self.ocplib-resto];
      tezos-rpc-http = addBuildInputs super.tezos-rpc-http [self.ocplib-resto-cohttp];
      cpuid = addBuildInputs super.cpuid [ fauxpam ];
      nocrypto = addBuildInputs super.nocrypto [ fauxpam ];
      tezos-node = addBuildInputs super.tezos-node [ pkgs.snappy ];
      hidapi = addBuildInputs super.hidapi [ pkgs.pkgconfig pkgs.hidapi ];
    });
  };
  node = opamSolution.packageSet.tezos-node;
  client = opamSolution.packageSet.tezos-client;
  baker-alpha = opamSolution.packageSet.tezos-baker-alpha;

  # pkgs.vmTools.buildRPM just builds, rpmBuild also installs
  tezos-rpm = pkgs.releaseTools.rpmBuild {
    name = "tezos-node-rpm";
    src = pkgs.runCommand "tezos-prebuilt.tar" {} ''
      mkdir -p tarball/tezos
      cp ${./tezos.spec} tezos.spec
      cp ${node}/bin/tezos-node tarball/tezos/tezos-node
      cp ${node}/bin/tezos-sandboxed-node.sh tarball/tezos/tezos-sandboxed-node.sh
      cp ${client}/bin/tezos-client tarball/tezos/tezos-client
      cp ${client}/bin/tezos-admin-client tarball/tezos/tezos-admin-client
      cp ${client}/bin/tezos-init-sandboxed-client.sh tarball/tezos/tezos-init-sandboxed-client.sh
      cp ${baker-alpha}/bin/tezos-baker-alpha tarball/tezos/tezos-baker-alpha

      tar -cf $out tezos.spec
      tar --transform='s#tarball/##' -rf $out tarball/tezos
    '';

    diskImage = pkgs.vmTools.diskImageFuns.fedora27x86_64 {
      extraPackages = [
        # for pkgs.vmTools.buildRPM, this is enough; but we need the install requirements too to check
        # BuildRequires
        "patchelf"
        # Requires
        "leveldb" "snappy" "hidapi"
        "bash" # rpmbuild is smart enough to notice we have installed files with shebangs
      ];
    };

    # check to make sure we have a working package... show the first few lines of the built in help
    postRPMInstall = ''
      /opt/tezos/bin/tezos-node --help=plain | head
    '';
  };

  tezos-deb = pkgs.releaseTools.debBuild {
    name = "tezos-node-deb";

    src = pkgs.runCommand "tezos-prebuilt.tar" {} ''
      mkdir -p tarball/tezos
      function patchbinary {
        patchelf --set-interpreter /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 --set-rpath /lib/x86_64-linux-gnu/:/usr/lib/x86_64-linux-gnu/ $1
      }
      cat > tarball/tezos/Makefile <<EOF
      install:
      ''\tinstall tezos-node tezos-client tezos-admin-client tezos-baker-alpha tezos-sandboxed-node.sh tezos-init-sandboxed-client.sh /usr/bin
      check:
      EOF
      cp ${node}/bin/tezos-node tarball/tezos/tezos-node
      cp ${node}/bin/tezos-sandboxed-node.sh tarball/tezos/tezos-sandboxed-node.sh
      cp ${client}/bin/tezos-client tarball/tezos/tezos-client
      cp ${client}/bin/tezos-admin-client tarball/tezos/tezos-admin-client
      cp ${client}/bin/tezos-init-sandboxed-client.sh tarball/tezos/tezos-init-sandboxed-client.sh
      cp ${baker-alpha}/bin/tezos-baker-alpha tarball/tezos/tezos-baker-alpha
      patchelf tarball/tezos/tezos-node
      patchelf tarball/tezos/tezos-client
      patchelf tarball/tezos/tezos-admin-client
      patchelf tarball/tezos/tezos-baker-alpha
      tar --transform='s#tarball/##' -rf $out tarball/tezos
    '';

    debRequires = ["libleveldb1v5" "libsnappy1v5"];

    diskImage = pkgs.vmTools.diskImageFuns.ubuntu1710x86_64 {
      extraPackages = [
        # BuildRequires
        "patchelf"
        # Requires
        "bash" "libleveldb1v5" "libsnappy1v5"
      ];
    };
  };

  sandbox =
      { expected_pow ? "20" # Floating point number between 0 and 256 that represents a difficulty, 24 signifies for example that at least 24 leading zeroes are expected in the hash.
      , datadir ? "./sandbox"
      , max_peer_id ? "9"
      , expected_connections ? "3"
      , time_between_blocks ? "[5, 5]"
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
      tezos-bake-monitor
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
      # TODO: protocol parameters, especially time_between_blocks
  } : pkgs.stdenv.mkDerivation {
    name = "tezos-sandbox";
    # src = lib.sourceByRegex ./. ["tezos.scripts.*" "tezos-loadtest.*"];
    sourceRoot = ".";
    srcs = [./tezos/scripts  ./tezos-load-testing ];

    configurePhase = "true";
    installPhase = "true";
    nativeBuildInputs = [pkgs.psmisc pkgs.jq node client];
    buildInputs = [pkgs.bash node client baker-alpha tezos-bake-monitor tezos-loadtest];
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
            "--rpc-addr=127.0.0.1:$((18730 + nodeid))"
            "--net-addr=127.0.0.1:$((19730 + nodeid))"
            "--expected-pow=${expected_pow}"
            "--closed"
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
          $out/bin/tezos-sandbox-client.sh import unencrypted secret key bootstrap\$i "\''${bootstrap_secrets[i]}"
        done

        $out/bin/tezos-sandbox-client.sh import unencrypted secret key dictator "edsk31vznjHSSpGExDMHYASz45VZqXN4DPxvsa4hAyY8dHM28cZzp6"
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
        # ${tezos-bake-monitor}/bin/tezos-bake-monitor --port "\$((9800 + bootstrapid))" --rpchost "http://127.0.0.1:\$((18730 + bootstrapid))" -- $out/bin/tezos-sandbox-client.sh launch daemon bootstrap\$bootstrapid -B -E -D >${datadir}/clientd-bootstrap\$bootstrapid.log 2>&1 &
        $out/bin/tezos-sandbox-client.sh launch daemon bootstrap\$bootstrapid -B -E -D >${datadir}/clientd-bootstrap\$bootstrapid.log 2>&1 &
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
          tezos-bake-monitor --port \$((9800 + i)) --rpchost 127.0.0.1:\$(((i - 1) % ${max_peer_id} + 18731)) --client $out/bin/tezos-sandbox-client.sh --identity "\''${!i}" & pid=\$!
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

      $out/bin/monitored-bakers.sh bootstrap0 bootstrap1 bootstrap2 bootstrap3 bootstrap4

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

  tezos-bake-central = pkgs.callPackage ./tezos-bake-monitor/tezos-bake-central {};

  # docker-image =
  # let
  #   pkgs = (import <nixpkgs> {});
  #   mySandbox = sandbox-env {
  #       expected_pow = "20";
  #       datadir = "./sandbox";
  #       max_peer_id = "9";
  #       expected_connections = "3";
  #       time_between_blocks = "[5, 5]";
  #     };
  # in pkgs.dockerTools.buildImage {
  #   name = "tezos";
  #   contents = [
  #     mySandbox
  #     node
  #     client
  #     tezos-bake-monitor
  #     tezos-loadtest
  #     pkgs.jq
  #   ];
  #   keepContentsDirlinks = true;
  #   config = {
  #     Env = [
  #       # When shell=true, mesos invokes "sh -c '<cmd>'", so make sure "sh" is
  #       # on the PATH.
  #       ("PATH=" + builtins.concatStringsSep(":")([
  #         "${pkgs.stdenv.shellPackage}/bin"
  #         "${pkgs.coreutils}/bin"
  #         "${node}/bin"
  #         "${client}/bin"
  #         "${mySandbox}/bin"
  #         "${pkgs.jq}/bin"
  #         ]))
  #     ];
  #     # Cmd = [ "${mySandbox}/bin/tezos-sandbox-theworks.sh" ];
  #     Cmd = [ "${mySandbox}/bin/tezos-sandbox-theworks.sh" ];
  #   };
  # };

}

