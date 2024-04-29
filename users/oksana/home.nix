{ pkgs, config, ... }: {
       home.username = "oksana";
       home.homeDirectory = "/home/oksana";

       home.stateVersion = "23.11";
       programs.home-manager.enable = true;
}