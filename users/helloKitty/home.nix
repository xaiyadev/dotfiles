{ lib, pkgs, config, ... }:
{
   home.username = "helloKitty";
   home.homeDirectory = "/home/helloKitty";

   /* TODO: Add Support for Server Account (no grahpical apps) */
   imports = [

        # --- APPS --- #
        ../../modules/apps/spotify
        ../../modules/apps/vesktop
        ../../modules/apps/chromium
        ../../modules/apps/zenlessZoneZero

        # -- CONFIG LOADER -- #
        ../../modules/apps/desktop/environment/gnome-config

    ];

   services.spotify.enable = true;

   services.chromium.enable = true;
   services.vesktop.enable = true;

   services.gnome-config.enable = true;

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

}