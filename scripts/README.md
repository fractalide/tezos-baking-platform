# Ledger Test Scripts

`fast-baking-sandbox.sh` runs a `nix-shell` command to enter into a Nix sandbox customized with
settings appropriate for baking testing (especially for the Ledger) by getting baking to move
quickly.

Within this Nix sandbox, general set up can be done with
`sandbox-nodes.sh`, which sets up a fresh Tezos genesis block and nodes
(killing all existing nodes) but does not run bakers. Bakers can be then
run with `bootstrap-baking.sh` which is not a script in this directory
but a command put in the path by Nix.

`zeronet-node.sh` creates a new node configuration if it hasn't been created, and then starts
a Zeronet node by querying what to connect to.

`theworks-more.sh` is a general test of Tezos functionality without Ledger included.

The testing scripts in the `ledger` directory (see `ledger/TESTING.md`) are similarly to be
run in the context of `fast-baking-sandbox.sh`'s `nix-shell`.
