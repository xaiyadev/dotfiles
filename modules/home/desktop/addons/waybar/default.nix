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
with lib.${namespace};
let
    cfg = config.${namespace}.desktop.addons.waybar;
in
{
    options.${namespace}.desktop.addons.waybar = {
        enable = mkBoolOpt false "Wehter or not to enable waybar and its configuration";

        /* If you would like, you could disable some of the modules you could do that! */
        modules = {
          workspaces.enable = mkBoolOpt true "Whether or not the workspaces module should be activated";
          window.enable = mkBoolOpt true "Whether or not the window module should be activated";
          pulseaudio.enable = mkBoolOpt true "Whether or not to enable the pulseaudio module";
          network.enable = mkBoolOpt true "Whether or not to enable the network module";
          disk.enable = mkBoolOpt true "Whether or not to enable the disk module";
          battery.enable = mkBoolOpt true "Whether or not to enable the battery module";
          clock.enable = mkBoolOpt true "Whether or not to enable the clock module";
          bluetooth.enable = mkBoolOpt true "Whether or not to enable the bluetooth module";
        };

    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [ waybar-mpris ];

      /* Install the style files */
      home.file.".config/waybar/" = { source = ./style; recursive = true; };

      programs.waybar = {
        enable = true;

        settings = {
          mainBar = {
            layer = "top";
            position = "top";

            margin = "3";
            height = 26;

            /* Enable modules in the right positions */
            modules-left = [ "sway/workspaces" "sway/window" ];
            modules-right = [  "pulseaudio" "bluetooth" "network" "disk" "battery" "clock" ];

            /* Show the sway workspaces in your waybar */
            "sway/workspaces" = mkIf cfg.modules.workspaces.enable {
              disable-scroll = true;
              all-outputs = true;
              disable-click = true;

              format = "{name} {icon}";

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

            /* Show the Active Window without icons */
            "sway/window" = mkIf cfg.modules.window.enable {
              all-outputs = true;
              icons = false;

              format = "| {title}";
              max-length = 30;
            };

            /*
             * Show the current connected Bluetooth devices
             * Enable: sylveon.hardware.bluetooth
             */
            "bluetooth" = mkIf cfg.modules.bluetooth.enable {
              format = " {status}";
              format-disabled = ""; # Disables the module if bluetooth is not available

              format-connected = " {device_alias}";
              format-connected-battery = " {device_alias} {device_battery_percantage}%"; # Needs bluetooth expirmental
              on-click = "exec ${pkgs.blueman}/bin/blueman";
            };



            /* Show the current audio device with icons and change the volume by scrolling */
            "pulseaudio" = mkIf cfg.modules.pulseaudio.enable {
              format = "{icon} {volume}%";
              format-bluetooth = "󰂰 {icon} {volume}%";
              format-source-muted = " ";
              format-icons = [ " " ];
            };

            /* Show the current network type; If the connection is LAN, show bandwith status with IP adress */
            "network" = mkIf cfg.modules.network.enable {
              interval = 3;
              format-wifi = "{icon} {essid} {signalStrength}%";
              format-disconnected = "{icon} ";
              format-ethernet = "󰌗 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
              format-icons = [ " " ];
            };

            /* The Battery status will be shown */
            "battery" = mkIf cfg.modules.battery.enable {
              interval = 10;
              tooltip = false;

              format = "{icon} {capacity}% {time}";
              format-icons = [ " " " " " " " " " " ];
            };

            /* Disk usage and percentage Free is shwon here */
            "disk" = mkIf cfg.modules.disk.enable {
              interval = 10;
              format = "󰆼 {percentage_free}% free";
              path = "/";
            };


            /* Show the current time (change formating here...) */
            "clock" = mkIf cfg.modules.clock.enable {
              interval = 60;

              timezone = "Europe/Berlin";
              locale = "de_DE.UTF-8";
              format = " {:%H:%M}";
            };

          };
        };

        /* Load the style files for waybar */
        style = ''
          @import "./rose-pine.css";
          @import "./index.css";
        '';

      };
    };
}