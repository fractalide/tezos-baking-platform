# Using Obsidian’s Tezos Baking Platform

To use Tezos via Obsidian Systems' Baking Platform, start by running the following Nix command. It should take less time to run if you have [set up nix caching](https://gitlab.com/obsidian.systems/tezos-baking-platform#setting-up-nix-caching-recommended). Replace `<network>` with your desired Tezos network, i.e. zeronet, alphanet, betanet.

```
$ nix-build -A tezos.<network>.sandbox
```

Once that `nix-build` compeletes, you can use the `tezos-client`, `tezos-node`, and other Tezos binaries as you normally would by prefixing your commands with `$(nix-build -A tezos.<network>.kit --no-out-link)/bin/`.

For example, if you'd like to run a Tezos node, use the following command, replacing `<network>` with the network you chose above.

```
$ $(nix-build -A tezos.<network>.kit --no-out-link)/bin/tezos-node run --rpc-addr :8732 --data-dir ~/.<network>-tezos-node
```

The `--rpc-addr` option opens the RPC port the node listens on. The `--data-dir` is where identity and chain data are stored. You'll need to use the `--data-dir` command so `tezos-node` knows where to find the correct directory.

To see all available binaries, run `$(nix-build -A tezos.<network>.kit --no-out-link)/bin/`, where `<network>` is the network used during your `nix-build`.
