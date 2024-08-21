{ lib, pkgs, config, ... }:
{
   home.username = "semiko";
   home.homeDirectory = "/home/semiko";

   imports = [
        # --- CORE --- #
        ../../../modules/core/git

        # --- APPS --- #
        ../../../modules/apps/spotify
        ../../../modules/apps/vesktop
        ../../../modules/apps/chromium

        ../../../modules/apps/steam
        ../../../modules/apps/AAGL/sleepy

        ../../../modules/apps/jetbrains/intellij
        ../../../modules/apps/jetbrains/webstorm
        ../../../modules/apps/virt-manager


        # -- CONFIG LOADER -- #
        ../../../modules/apps/desktop/environment/gnome-config
    ];


   # TODO: make modules
   home.packages = with pkgs;[
        # Gaming
        steam

        # School :3
        teams-for-linux


   ];
   services.spotify.enable = true;

   services.intellij.enable = true;
   services.webstorm.enable = true;
   services.virt-manager.enable = true;

   services.chromium.enable = true;
   services.vesktop.enable = true;
   services.gnome-config.enable = true;


   services.steam.enable = true;
   services.sleepy.enable = true;

   services.git = {
        enable = true;
        email = "danil80sch@gmail.com";
   };


  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

}