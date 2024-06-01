{ lib, pkgs, config, ... }: {
   home.username = "semiko";
   home.homeDirectory = "/home/semiko";

   imports = [
        # --- GENERAL --- #
        ../../modules/spotify
	    ../../modules/vesktop

	    ../../modules/gnome/home-config.nix

	    # --- GAMING --- #
        ../../modules/minecraft/lunar.nix

    ];

    home.packages = with pkgs; [
	  # Jetbrains IDE for specific languages » TODO: Sync all thes config via Repository, not Settings Sync

	  # --- DEVELOPMENT/GENERAL --- #
      jetbrains.webstorm
      jetbrains.pycharm-professional
      jetbrains.idea-ultimate

      virt-manager

      obsidian

      # --- GAMING --- #
      steam
      lunar-client

      lutris
      vkd3d-proton
   ];

   programs.git = {
     enable = true;
     package = pkgs.gitFull;
     userName = "Danil Schumin";
     userEmail = "danil80sch@gmail.com";

     extraConfig = {
         commit.gpgsign = true;
         gpg.format = "ssh";
         user.signingkey = "~/.ssh/gitlab_ssh_key.pub";
         safe.directory = "/srv/shared/obsidian/obsidian-sync";
     };
   };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

}

