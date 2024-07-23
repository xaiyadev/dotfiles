{ lib, pkgs, config, ... }:
{
   home.username = "semiko";
   home.homeDirectory = "/home/semiko";

   /* TODO: Add Support for Server Account (no grahpical apps) */
   imports = [
        # --- CORE --- #
        ../../modules/core/git

        # --- APPS --- #
        ../../modules/apps/spotify
        ../../modules/apps/vesktop
        ../../modules/apps/chromium

        ../../modules/apps/jetbrains/intellij
        ../../modules/apps/jetbrains/webstorm


        # -- CONFIG LOADER -- #
        ../../modules/apps/desktop/environment/gnome-config
    ];
   services.spotify.enable = true;

   services.intellij.enable = true;
   services.webstorm.enable = true;

   services.chromium.enable = true;
   services.vesktop.enable = true;

   services.git = {
        enable = true;
        email = "danil80sch@gmail.com";
   };
   services.gnome-config.enable = true;



  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

}