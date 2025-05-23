{ inputs', lib, self, osConfig, ... }:
let
  inherit (lib) mkIf;

  inherit (self.lib.validation) isGraphical;
  ulauncher6 = inputs'.ulauncher.packages.ulauncher6;
in
{
  config = {
    home.packages = mkIf (isGraphical osConfig) [ ulauncher6 ];

    # Startup daemon service for ulauncher
    wayland.windowManager.sway.extraConfig = ''exec ${ulauncher6}/bin/ulauncher --daemon'';

    # Add Ulauncher toggle as menu option
    wayland.windowManager.sway.config.menu =
      "${ulauncher6}/bin/ulauncher-toggle";

  };

}