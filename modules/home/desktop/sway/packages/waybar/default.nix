{ pkgs, osConfig, lib, config, ... }:
let
  inherit (lib) mkIf;

  windowManagers = osConfig.sylveon.system.graphical.windowManagers;
in
{

  imports = [
    ./modules/sway.nix
    ./modules/control_center.nix
    ./modules/clock.nix
    ./modules/battery.nix
    ./modules/mpris.nix
    ./modules/tray.nix
  ];

  # replace default bar with waybar
  wayland.windowManager.sway.config.bars = mkIf (builtins.elem "sway" windowManagers) [ { command = "${pkgs.waybar}/bin/waybar"; }];

  # only add colors and fonts from stylix
  stylix.targets.waybar.addCss = false;

  programs.waybar = {
    enable = builtins.elem "sway" windowManagers;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        fixed-center = true;

        height = 35;
        margin-top = 5;
        margin-left = 5;
        margin-right = 5;

        margin-bottom = 3;


        /* Enable modules in the right positions */

        modules-left = [ "image#nix" "sway/workspaces" "sway/window" ];
        modules-center = [ /* "custom/weather" */ "clock" ];
        modules-right = [  "mpris" "pulseaudio" "network" "bluetooth"  "tray" "battery" ];

        "image#nix" = {
          path = "${./lix.svg}";
          size = 20;
        };
      };
    };



    style = builtins.readFile ./style.css;

  };
}