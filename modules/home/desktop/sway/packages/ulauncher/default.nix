{ inputs', ... }:
let
  ulauncher6 = inputs'.ulauncher.packages.ulauncher6;
in
{

  # TODO: configure ulauncher
  # home.file.".config/ulauncher" = { source = ./config; recursive = true; };

  home.packages = [ ulauncher6 ];

  # Startup daemon service for ulauncher
  wayland.windowManager.sway.extraConfig = ''exec ${ulauncher6}/bin/ulauncher --daemon'';

  # Add Ulauncher toggle as menu option
  wayland.windowManager.sway.config.menu =
    "${ulauncher6}/bin/ulauncher-toggle";


}