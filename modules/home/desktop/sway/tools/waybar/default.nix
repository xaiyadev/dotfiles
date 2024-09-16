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
    cfg = config.${namespace}.desktop.config.sway.tools.waybar;
in
{
    options.${namespace}.desktop.config.sway.tools.waybar = {
        enable = mkEnableOption "Setup Waybar!";
    };

    config = mkIf cfg.enable {
      home.file.".config/waybar/scripts/mediaplayer.py".source = ./scripts/mediaplayer.py;

      home.file.".config/waybar/rose-pine.css".source = ./style/rose-pine.css;
      home.file.".config/waybar/index.css".source = ./style/index.css;


      programs.waybar = {
        enable = true;
        systemd.enable = true;

        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 26;

            modules-left = [ "sway/workspaces" ];
            modules-center = [ "clock" /*"custom/mediaplayer"*/ ];
            modules-right = [ "disk" "network" "cpu" "memory" "battery" ];

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



            "cpu" = {
                interval = 10;
                format = "⚙️ CPU: {}%";
            };

            "memory" = {
                interval =  10;
                format = "RAM: {}%";
             };

            "battery" = {
              tooltip = false;
              format = "{icon} {capacity}% // {time}";
              format-charging = "{icon} {capacity}% // {time}";
              format-full = "{icon} {capacity}%";
              format-icons = [ "🍎⚠️" "🌻" "🍃" ];
            };

            "network" = {
              interval = 10;
              format = "🌐⚡ {essid} // {ipaddr}";
            };

            "disk" = {
              interval = 10;
              format = "/ {percentage_free}% free";
              path = "/";
            };

          };
        };

        style = ''
          @import "./rose-pine.css";
          @import "./index.css";
        '';

      };
    };
}