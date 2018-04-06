
{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
	# For development, set OPAM2NIX_DEVEL to your local
	# opam2nix repo path
	devRepo = builtins.getEnv "OPAM2NIX_DEVEL";
	src = ./opam2nix-packages;
	opam2nix = fetchgit 	{
		"url" = "https://github.com/obsidiansystems/opam2nix.git";
		"fetchSubmodules" = false;
		"sha256" = "1l941zq4qrspqg9zl3j5k6lp161iha1ifky5r1576gz4a2cfplk0";
		"rev" = "9c593cdbcf45192639d3d647cbd887622780d9a2";
	};
in
if devRepo != "" then
	let toPath = s: /. + s; in
	callPackage "${devRepo}/nix" {} {
                inherit src opam2nix;
		#src = toPath "${devRepo}/nix/local.tgz";
		#opam2nix = let devSrc = "${devRepo}/opam2nix/nix/local.tgz"; in
		#	if builtins.pathExists devSrc then toPath devSrc else opam2nix;
	}
else callPackage "${src}/nix" {} { inherit src opam2nix; }
