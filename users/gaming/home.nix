{ lib, pkgs, config, ... }: {

    /* TODO:
        - NFS Filesystem for Installed games
        - Automatic Install of Games and coresponding folders
     */

   home.username = "gaming";
   home.homeDirectory = "/home/gaming";

   imports = [
        ../../modules/spotify
	    ../../modules/vesktop

	    ../../modules/gnome/home-config.nix
    ];

    home.packages = with pkgs; [
            steam
            lunar-client

            lutris
	    vkd3d-proton

            waydroid

            gnome3.adwaita-icon-theme
    ];

   home.stateVersion = "23.11";
   programs.home-manager.enable = true;
}

