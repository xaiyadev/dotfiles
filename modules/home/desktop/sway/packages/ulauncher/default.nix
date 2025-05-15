{ inputs', lib, osConfig, ... }:
let
  inherit (lib) mkIf;


  windowManagers = osConfig.sylveon.system.graphical.windowManagers;
  ulauncher6 = inputs'.ulauncher.packages.ulauncher6;
in
{
  config = mkIf (builtins.elem "sway" windowManagers) {

    # TODO: configure ulauncher/rose-pine
    home.file.".config/ulauncher" = { source = ./config; recursive = true; };

    home.packages = [ ulauncher6 ];

    # Startup daemon service for ulauncher
    wayland.windowManager.sway.extraConfig = ''exec ${ulauncher6}/bin/ulauncher --daemon'';

    # Add Ulauncher toggle as menu option
    wayland.windowManager.sway.config.menu =
      "${ulauncher6}/bin/ulauncher-toggle";

  };

}