{ pkgs, config, ... }: {
       home.username = "oksana";
       home.homeDirectory = "/modules/oksana";

       home.stateVersion = "23.11";
       programs.home-manager.enable = true;
}