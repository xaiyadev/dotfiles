{ pkgs, config, ... }: {
       home.username = "oksana";
       home.homeDirectory = "/home/oksana";

       programs.chromium.enable = true;

       home.stateVersion = "23.11";
       programs.home-manager.enable = true;
}