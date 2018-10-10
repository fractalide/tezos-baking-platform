# Overview

Tezos Baking Platform is Obsidian Systems' collection of Tezos tools and resources for bakers. It requires the [Nix](https://nixos.org/nix/) Package Manager, which you can install on any Linux distribution or MacOS. 

## Ledger Nano S Applications 

Obsidian Systems has developed two Tezos applications for the Ledger Nano S hardware wallet.
* Tezos Wallet - Used for storing, sending, and delegating
* Tezos Baking - Used for signing blocks, endorsements, and self-delegating

Both are available to download in [Ledger Live](https://www.ledger.com/pages/ledger-live). To obtain them, enable Developer Mode in Settings; you’ll then find them available for download in Ledger Live’s Manager. Downloading these applications from Ledger Manager is not recommended, as those applications are out of date and are not updated.

For instructions on installing Tezos Wallet and Tezos Baking via the command line, visit our [Tezos Ledger Applications Github](https://github.com/obsidiansystems/ledger-app-tezos) repo. You'll also find instructions for their use. If you would like to build the applications yourself, see [BUILDING.md](https://gitlab.com/obsidian.systems/tezos-baking-platform/blob/develop/ledger/BUILDING.md) in the ledger folder. You’ll also find [instructions for testing scripts](https://gitlab.com/obsidian.systems/tezos-baking-platform/blob/develop/ledger/TESTING.md) there. 

## Monitoring Software

Our Monitoring Software is the first stage of our Baking Software. For instructions on installation and use, see the [Tezos Bake Monitor](https://gitlab.com/obsidian.systems/tezos-bake-monitor) repo.

## Connecting to Tezos

You can connect to Tezos by building it from source or by using docker images. Please see the [Tezos Documentation](http://tezos.gitlab.io/) for instructions.

If you have the [Nix](https://nixos.org/nix/) Package Manager, you can also use Obsidian Systems’ Tezos Baking Platform. Instructions can be found in [UsingTezos.md](UsingTezos.md).

# Obtaining Tezos Baking Platform

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

# Setting up Nix Caching (Recommended)

If you have not already, we recommend you setup Nix caching to drastically reduce your build times.

## NixOS

If you are running NixOS, add this to `/etc/nixos/configuration.nix`: 

```
nix.binaryCaches = [ 
"https://cache.nixos.org/" 
"https://nixcache.reflex-frp.org" 
];

nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
];
```

## Linux or MacOS

Include these lines in `/etc/nix/nix.conf`. If the nix directory or `nix.conf` file do not yet exist then you will need to create them.

```
substituters = 
https://cache.nixos.org https://nixcache.reflex-frp.org

trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=
```

If you are using **Linux** then enable sandboxing by adding this line to the `nix.conf` file

```
sandbox = true
```

But if you are using **MacOS** then you will need to disable sandboxing and then restart the nix daemon. Add this line to the `nix.conf` file to disable sandboxing

```
sandbox = false
```

Use these commands to restart the nix daemon:

```
$ sudo launchctl stop org.nixos.nix-daemon
$ sudo launchctl start org.nixos.nix-daemon
```
