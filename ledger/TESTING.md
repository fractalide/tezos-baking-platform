# Running the Ledger Tests

Under `scripts` run `fast-baking-sandbox.sh`:

```
$ scripts/fast-baking-sandbox.sh
```

This is a sandbox environment where the protocol parameters are such that the time between blocks is
3 seconds rather than a minute, which allows baking to happen on the Ledger much sooner during the
process. Within the sandbox nix shell, run:

```
$ ledger/sandbox-tests.sh
```

This will perform a number of actions using the Ledger, which should
start out open to the Baking App. Currently, which Ledger is to be used
is hard-coded into the script. This can result in the following error:

```
Error:
  Error:
    No Ledger found for tz1VasatP7zmHDxPeBn97YoSFowXLdsBAdW9
```

If you see this error, please edit the script so that instead of `tz1VasatP7zmHD...`, it instead
refers to the `tz1...` string from `tezos-client list connected ledgers`.

It then goes through the following steps:

  * First, it imports the key.
  * Then, it does a self-delegation, which the Baking App should interpret as a request for baking
    authorization, and sign.
  * Then, it attempts a transaction -- which it will retry and fail at until you switch to the Wallet App.
  * Then, it attempts a reset of HWM -- which it will retry and fail at until you switch back to the
    Baking App.
  * Then, it bakes. At some point, you should see something like this:

    ```
    Injected block BLabDMsNsU3g for my-ledger after BMcko9tfLNju (level 48, slot 0, fitness 00::0000000000000043, operations 0+0+0+0)
    ```

    This means that it baked a block at level `48`, and you should
    also see a `48` (or higher -- whatever was most recently reached)
    displayed on the Ledger (when it's not displaying the baking key,
    which it does most of the time).

If any of these steps don't happen/fail even when you're using the right
app/keep on retrying over and over again, then there might be a problem
with the Ledger app. Try running the commands in `ledger-tests.sh`
one by one to see what might have failed.
