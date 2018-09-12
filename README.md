# Ledger Set Up

These instructions require NixOS, or the [Nix](https://nixos.org/nix/) package
manager which you can install on any Linux distribution.

## Obtaining the baking platform

Please clone the
[Tezos Baking Platform](https://gitlab.com/obsidian.systems/tezos-baking-platform) and
check out the `develop` branch, updating submodules. These are the commands to run
in the freshly-cloned repo:

```
$ git clone https://gitlab.com/obsidian.systems/tezos-baking-platform.git
$ cd tezos-baking-platform
$ git checkout develop
$ git submodule sync
$ git submodule update --recursive --init
```

## Running a Zeronet Node

Enter the sandbox shell in the `tezos-baking-platform` working copy's root directory:

```
$ nix-shell -A sandbox \
    --option binary-caches "https://cache.nixos.org/ https://nixcache.reflex-frp.org/" \
    --option binary-cache-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
```

And this script will run a node on zeronet:

```
$ scripts/zeronet-node.sh
```

The node needs to remain running while you run all of the `tezos-client`
commands.

## Running the client

In a new terminal, enter a nix shell that has `tezos-client` available:

```
$ nix-shell \
    --option binary-caches "https://cache.nixos.org/ https://nixcache.reflex-frp.org/" \
    --option binary-cache-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" \
    --attr client
```

Now jump back to the
[ledger-app-tezos](https://github.com/obsidiansystems/ledger-app-tezos)
instructions. All commands there that use `tezos-client` will need to be run in
this shell.

## Resetting the high water mark

The test network is not so immutable as the real blockchain, and so sometimes
you might want to reset your Ledger Baking state to allow it go back to a lower
block height.

Open the Tezos Baking app on the Ledger, and run this:

```
$ tezos-client reset ledger high watermark to 0
```

## Using Docker for bake monitor

Create docker image (with Nix)

```
$ docker load -i $(nix-build -A bake-central-docker --no-out-link)
$ docker run -p=127.0.0.1:8000:8000 tezos
```

# Running the Bake Monitor via Docker

1) Build the bake monitor Docker image via `nix`.

[You need nix 2. Check with `nix --version`.]

```shell
docker load -i $(nix-build -A bake-central-docker --no-out-link)
```

2) Create a Docker network to connect multiple containers.

```shell
docker network create tezos-bake-network
```

3) Start a Postgres database instance in the network.

```shell
docker pull postgres
docker run --name bake-monitor-db --detach --network tezos-bake-network -e POSTGRES_PASSWORD=secret postgres
```

4) Start the bake monitor Docker container in the same network and connect it to the appropriate database.

```shell
docker run --rm -p=8000:8000 --network tezos-bake-network tezos-bake-monitor --pg-connection='host=bake-monitor-db dbname=postgres user=postgres password=secret'
```

5) Visit the bake monitor at `http://localhost:8000`.
