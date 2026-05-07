{
  pkgs,
  osConfig,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;

  inherit (osConfig.sylveon.graphical) sway;
in
{

  imports = [
    ./modules
  ];

  config = mkIf sway.enable {
    # replace default bar with waybar
    wayland.windowManager.sway.config.bars = [ { command = "${pkgs.waybar}/bin/waybar"; } ];

    catppuccin.waybar.enable = true;

    programs.waybar = {
      # TODO: replace?
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          fixed-center = true;

          height = 37;
          margin-top = 10;
          margin-left = 10;
          margin-right = 10;

          margin-bottom = 10;

          # Enable modules in the right positions
          modules-left = [
            # "image#nix"
            "sway/workspaces"
            "sway/window"
          ];
          modules-center = [
            # "custom/weather"
            "clock"
          ];
          modules-right = [
            "pulseaudio"
            "network"
            "bluetooth"
            "tray"
            "battery"
          ];

          "image#nix" = {
            path = "${./lix.svg}";
            size = 20;
          };
        };
      };

      style = builtins.readFile ./style.css;

    };
  };

}
