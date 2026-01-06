{
	inputs,
	config,
	lib,
	...
}:
let
  prof = config.sylveon.profiles;
in
{
	# Some catppuccin configuration only work on nixos
	# This file might be changed because the idea of theming will be renewed

	imports = [ inputs.catppuccin.nixosModules.catppuccin ];

	config = {
	  catppuccin = {
	    inherit (prof.graphical) enable;
	    cache.enable = true;

      accent = "flamingo";
      flavor = "mocha";
		};

		# https://github.com/isabelroses/dotfiles/blob/88d1cb29e2da4ef977b4a06fcbf9a22efbd398a7/modules/nixos/catppuccin.nix#L21
		console.colors = lib.mkIf config.catppuccin.enable [
		  "1e1e2e"
      "f38ba8"
      "a6e3a1"
      "f9e2af"
      "89b4fa"
      "f5c2e7"
      "94e2d5"
      "bac2de"
      "585b70"
      "f38ba8"
      "a6e3a1"
      "f9e2af"
      "89b4fa"
      "f5c2e7"
      "94e2d5"
      "a6adc8"
		];
	};
}