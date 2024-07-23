{ lib, pkgs, config, ... }:
let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in
{
   home.username = "semiko";
   home.homeDirectory = "/home/semiko";

   imports = [

        # --- GENERAL --- #
        ../../modules/graphical/spotify
	    ../../modules/graphical/vesktop
	    ../../modules/graphical/gnome/home-config.nix

	    # --- GAMING --- #
        ../../modules/graphical/lunar.nix

    ];




    home.packages = with pkgs; [
	  # Jetbrains IDE for specific languages » TODO: Sync all thes config via Repository, not Settings Sync

	  # --- DEVELOPMENT/GENERAL --- #
      jetbrains.webstorm
      jetbrains.idea-ultimate

      chromium

      virt-manager

      obsidian

      # --- GAMING --- #
      steam

      lutris
      vkd3d-proton

      rpcs3

      aagl-gtk-on-nix.sleepy-launcher
   ];

   programs.git = {
     enable = true;
     package = pkgs.gitFull;
     userName = "Danil Schumin";
     userEmail = "danil80sch@gmail.com";

     extraConfig = {
         commit.gpgsign = true;
         gpg.format = "ssh";
         user.signingkey = "~/.ssh/git_ssh_key.pub";
     };
   };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

}

