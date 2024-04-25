{ pkgs, config, ... }: {

      imports = [
           ../../modules/programs/git.nix
      ];

       home.username = "semiko";
       home.homeDirectory = "/home/semiko";

        home.packages = with pkgs; [
              jetbrains.webstorm
        ];

       home.stateVersion = "23.11";
       programs.home-manager.enable = true;
}