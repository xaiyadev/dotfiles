{ pkgs, lib, self, osConfig, inputs, ... }:
let
  inherit (lib) mkIf;

  inherit (self.lib.validation) isGraphical;
in
{
  config = mkIf (isGraphical osConfig) {
    home.packages = [ pkgs.ulauncher ];

    # Add Ulauncher Theme
    home.file.".config/ulauncher/user-themes/rose-pine" = {
      source = "${inputs.rose-pine-ulauncher}/dist/rose-pine";
      recursive = true;
    };

    # Startup daemon service for ulauncher
    wayland.windowManager.sway.extraConfig = ''exec ${pkgs.ulauncher}/bin/ulauncher --hide-window'';

    # Add Ulauncher toggle as menu option
    wayland.windowManager.sway.config.menu =
      "${pkgs.ulauncher}/bin/ulauncher-toggle";

  };

}