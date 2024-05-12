{ lib, pkgs, config, ... }: {
   home.username = "semiko";
   home.homeDirectory = "/home/semiko";

   imports = [
        ../../modules/spotify
	    ../../modules/vesktop

        ../../modules/obsidian/home-config.nix
	    ../../modules/gnome/home-config.nix
    ];

    home.packages = with pkgs; [
	  # Jetbrains IDE for specific languages » TODO: Sync all thes config via Repository, not Settings Sync

      jetbrains.webstorm
	  jetbrains.pycharm-professional
	  jetbrains.idea-ultimate
    ];

   home.stateVersion = "23.11";
   programs.home-manager.enable = true;


   # Programm Settings for only that specific User
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
}

