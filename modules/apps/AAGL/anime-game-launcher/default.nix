{pkgs, ...}: let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in
/* TODO: code to config */
{ 
    home.packages = with pkgs; [ 
	# programs needed for installation
	git
	p7zip
	libwebp

	aagl-gtk-on-nix.anime-game-launcher
    ]; 
}
