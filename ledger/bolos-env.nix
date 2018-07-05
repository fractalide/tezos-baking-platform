{ pkgs ? import ../nixpkgs.nix {} }:
let
  clang = pkgs.requireFile {
    url = http://releases.llvm.org/4.0.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.10.tar.xz;
    sha256 = "0j0kc73xvm2dl84f7gd2kh6a8nxlr7alk91846m0im77mvm631rv";
  };
  gcc = pkgs.requireFile {
    url = https://launchpadlibrarian.net/251687888/gcc-arm-none-eabi-5_3-2016q1-20160330-linux.tar.bz2;
    sha256 = "08x2sv2mhx3l3adw8kgcvmrs10qav99al410wpl18w19yfq50y11";
  };
in pkgs.runCommand "bolos-env" {} ''
  mkdir $out
  mkdir $out/clang-arm-fropi
  tar xavf ${clang} --strip-components=1 -C $out/clang-arm-fropi
  mkdir $out/gcc-arm-none-eabi-5_3-2016q1
  tar xavf ${gcc} --strip-components=1 -C $out/gcc-arm-none-eabi-5_3-2016q1
''
