# Ledger Test Scripts

`jimmy-sandbox.sh` runs a `nix-shell` command to enter into a Nix sandbox customized with
settings appropriate for Ledger Baking testing by getting the Ledger delegated to bake
relatively quickly.

Within this Nix sandbox, general set up can be done with `jimmy-sandbox-setup.sh`, which
sets up a fresh Tezos and a genesis block but does not run bakers. Bakers can be then run
with `bootstrap-baking.sh` which is not a script in this directory but a command put in
the path by Nix.

`jimmy-works-inner.sh` runs both of those and then runs a series of test commands designed
to test both the baking app and the wallet app.

`jimmy-works.sh` does all of this from outside any sandbox: It sets up the Nix sandbox and then
runs `jimmy-works-inner.sh` inside of it, giving excerpts from its output and logging the full
output to a file within `LOGS/` in the `tezos-baking-platform` directory.

`zeronet-node.sh` creates a new node configuration if it hasn't been created, and then starts
a Zeronet node by querying what to connect to.

`theworks-more.sh` is a general test of Tezos functionality without Ledger included.
