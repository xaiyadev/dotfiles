{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  config,
  specialArgs,
  ...
}:
with lib;
let
    cfg = config.${namespace}.tools.waybar;
in
{
    options.${namespace}.tools.waybar = {
        enable = mkEnableOption "Setup Waybar!";
    };

    config = mkIf cfg.enable {
      home.file.".config/waybar/scripts/mediaplayer.py".source = ./scripts/mediaplayer.py;


      # TODO: fix long startup time
      programs.waybar = {
        enable = true;
        systemd.enable = true;

        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 26;

            modules-left = [ "custom/logo" "sway/workspaces" ];
            modules-center = [ "clock" /*"custom/mediaplayer"*/ ];
            modules-right = [ "battery" ];

            "custom/logo" = {
              format = "🎉";
              tooltip = false;
              on-click = ''wofi --show run'';
            };

 /*           "custom/spotify" = {
              exec = "~/.config/waybar/scripts/mediaplayer.py --player spotify";
              format = "{} 🎸";
              return-type = "json";
              on-click = "playerctl play-pause";
            };*/

            "sway/workspaces" = {
              disable-scroll = true;
              all-outputs = false;
              disable-click = true;

              format = "{name}: {icon}";

              format-icons = {
                "1" = "🔥";
                "2" = "✨";
                "3" = "🎉";
                "4" = "🎸";
                "5" = "🧋";
                "default" = "🔆";
              };
            };

            "clock" = {
              interval = 60;
              format = "{:%a %d/%m %I:%M}";
            };

            "battery" = {
              tooltip = false;
              format = "{icon} {capacity}% // Time left: {time}";
              format-icons = [ "🍎⚠️" "🌻" "🍃" ];
            };
          };
        };

      };
    };
}