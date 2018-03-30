
{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
	# For development, set OPAM2NIX_DEVEL to your local
	# opam2nix repo path
	devRepo = builtins.getEnv "OPAM2NIX_DEVEL";
	src = fetchgit 	{
		"url" = "https://github.com/timbertson/opam2nix-packages.git";
		"fetchSubmodules" = false;
		"sha256" = "1xx43fd3c0kj17f7q767l6h3zw2kjaii8q6r91ms37gpb0m3p305";
		"rev" = "8549c71e487b33e4e8860fdac3abe96657c58e23";
	};
	opam2nix = fetchgit 	{
		"url" = "https://github.com/timbertson/opam2nix.git";
		"fetchSubmodules" = false;
		"sha256" = "1vj2pjwfil7h8czbrknfq6py33p5cz12cyfxj8yq190lmwcimhcb";
		"rev" = "790acd3b949540aa4b1e1cf580a03e36f52ae75b";
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
