#!/usr/bin/env bash
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

{
    echo 8004000011048000002c800006c18000000080000000
    echo 800481009301d31fc1560000040f01e2333a7edebac69d8213e420f30d5f0ead2df6041defac7bcbd30ee1fff09422000000005b34bf5d04a7da87564f2de039388d146c426548d18abe95db3938311776b8276aa76e87b1000000110000000100000000080000000000005be2cfece538e37ab260438cb57b3e4688e369711fa57fe49d00cec8d71fe26be6720001cab758186f0cc38200

} | nix-shell ledger-blue-shell.nix --pure --run 'python -m ledgerblue.runScript --apdu'
