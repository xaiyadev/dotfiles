{ lib, pkgs, config, ... }: {
   home.username = "semiko";
   home.homeDirectory = "/home/semiko";

    home.packages = with pkgs; [
          jetbrains.webstorm
    ];

   home.stateVersion = "23.11";
   programs.home-manager.enable = true;

   programs.git = {
     enable = true;
     package = pkgs.gitFull;
     userName = "Danil Schumin";
     userEmail = "danil80sch@gmail.com";

     extraConfig = {
         commit.gpgsign = true;
         gpg.format = "ssh";
         user.signingkey = "~/.ssh/gitlab_ssh_key.pub";
     };
   };
}

