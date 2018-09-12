# Building and Installing Ledger Apps

Follow only the *Ledger firmware update* and *udev rules* instructions from the
[ledger-app-tezos](https://github.com/obsidiansystems/ledger-app-tezos#instructions-for-nixos)
instructions.

Make sure your Ledger is plugged in and on the app selection screen. Then run
this script to install both the Tezos Baking and Tezos Wallet applications onto
your Ledger:

```
$ ledger/setup_ledger.sh
```

and follow the prompts on your Ledger device. This will require a couple of
confirmation button presses, and entering your PIN twice.

The first time you run this, you will be prompted to download some large files
and manually add them to your Nix store. This is due to a known limitation of
Nix; it is not a fatal error message, just a little additional work. Following
the instructions from the error message will look like this:

```
$ wget http://releases.llvm.org/4.0.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.10.tar.xz
$ nix-store --add-fixed sha256 clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.10.tar.xz
$ wget https://launchpadlibrarian.net/251687888/gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2
$ nix-store --add-fixed sha256 gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2
```

and then run the script again.
