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
      home.file.".config/waybar/scripts/wireguard-manager.sh" = {
        source = ./scripts/wireguard-manager.sh;
        executable = true;
      };

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

            modules-left = [ "sway/workspaces" "sway/window" ];
            modules-center = [ "clock" ];
            modules-right = [  "pulseaudio" "network" "custom/wireguard-manager" "disk" "battery"  ];

 /*           "custom/spotify" = {
              exec = "~/.config/waybar/scripts/mediaplayer.py --player spotify";
              format = "{} 🎸";
              return-type = "json";
              on-click = "playerctl play-pause";
            };*/

            "sway/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
              disable-click = true;

              format = "{name}: {icon}";

              format-icons = {
                "1" = "🔥";
                "2" = "✨";
                "3" = "🎉";
                "4" = "🎸";
                "5" = "🧋";
                "6" = "🐈‍⬛";
                "7" = "🎯";
                "8" = "🎇";
                "9" = "〽️";
                "10" = "✴️";
              };
            };

            "sway/window" = { 
              all-outputs = true;
              "format" = "{title}";
              "icon" = true;
              "icon-size" = 18;
              "max-length" = 50;
            };

            "clock" = {
              interval = 60;
              format = "{:%a %d/%m %I:%M}";
            };

            "pulseaudio" = {
                "format" = "{icon} {volume}%";
                "format-bluetooth" = "{icon} {volume}%";
                "format-icons" = {
                  "hdmi" = "🖥️";
                  "default" = "🔊";
                };
            };

            "network" = {
              interval = 3;
              format-wifi = "{icon} {essid} // {ipaddr} // signal: {signalStrength}%";
              format-disconnected = "{icon} no connection :/";
              format-icons = [ "🌐⚡" ];
            };


            "custom/wireguard-manager" = {
                interval = 3;
                return-type = "json";

                format-icons = {
                    connected = "<span color=\"#50fa7b\">VPN: 🔒</span>";
                    disconnected = "<span color=\"#ff5555\">VPN: 🔓</span>";
                };

                on-click = "exec ~/.config/waybar/scripts/wireguard-manager.sh -t";
                format = "{icon}";
                exec = "exec ~/.config/waybar/scripts/wireguard-manager.sh -s";
            };

            "battery" = {
              interval = 10;
              tooltip = false;
              states = {
                "full" = 100;
                "warning" = 30;
                "critical" = 10;
              };

              format = "{icon} {capacity}% // {time}";
              format-icons = [ "🍎⚠️" "🌻" "🍃" ];
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