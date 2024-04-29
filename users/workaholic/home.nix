{ pkgs, config, ... }: {
   home.username = "workaholic";
   home.homeDirectory = "/home/workaholic";

   imports = [ ../../modules/spotify ];

    home.packages = with pkgs; [
          jetbrains.phpstorm
          teams-for-linux
          enpass
          thunderbird
    ];

   programs.git = {
     enable = true;
     package = pkgs.gitFull;
     userName = "Danil Schumin";
     userEmail = "d.schumin@blmedia.de";

     extraConfig = {
         commit.gpgsign = true;
         gpg.format = "ssh";
         user.signingkey = "~/.ssh/bitbucket_ssh_key.pub";
     };
   };

   home.stateVersion = "23.11";
   programs.home-manager.enable = true;
}
