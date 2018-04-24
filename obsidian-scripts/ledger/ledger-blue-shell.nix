let nixpkgs_path = (import <nixpkgs> {}).fetchFromGitHub {
  owner = "NixOS";
  repo = "nixpkgs";
  rev = "e3be0e49f082df2e653d364adf91b835224923d9";
  sha256 = "15xcs10fdc3lxvasd7cszd6a6vip1hs9r9r1qz2z0n9zkkfv3rrq";
};
nixpkgs=import nixpkgs_path{};
in
    nixpkgs.runCommand "ledger-blue-shell" {
        buildInputs = with nixpkgs.python36Packages; [ ecpy hidapi pycrypto python-u2flib-host requests ledgerblue pillow nixpkgs.hidapi ];
        inherit nixpkgs_path;
    } ""
