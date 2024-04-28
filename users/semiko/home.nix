{ pkgs, config, ... }: {

      imports = [
           ../../modules/programs/git/gitlab.nix
      ];

       home.username = "semiko";
       home.homeDirectory = "/modules/semiko";

        home.packages = with pkgs; [
              jetbrains.webstorm
        ];

       home.stateVersion = "23.11";
       programs.home-manager.enable = true;
}