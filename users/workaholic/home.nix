{ pkgs, config, ... }: {
   home.username = "workaholic";
   home.homeDirectory = "/home/workaholic";

   imports = [
     ../../modules/spotify
     ../../modules/vesktop
     ../../modules/gnome/home-config.nix
   ];

    home.packages = with pkgs; [
          jetbrains.phpstorm
          teams-for-linux
          enpass
          thunderbird
	  obsidian
    ];


   # Programm Settings for only that specific User
   programs.git = {
     enable = true;
     package = pkgs.gitFull;
     userName = "Danil Schumin";
     userEmail = "d.schumin@blmedia.de";

     extraConfig = {
         commit.gpgsign = true;
         gpg.format = "ssh";
         user.signingkey = "~/.ssh/bitbucket_ssh_key.pub";
         safe.directory = "/srv/shared/obsidian/obsidian-sync";
     };
   };

   home.stateVersion = "23.11";
   programs.home-manager.enable = true;
}
