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

            # left: workspaces; window
            # middle: clock;date (?media player)
            # right: ((wifi/ethernet; VPN;) bluetooth) (battery; sound; brightness;) swaync; menu:(lock;shutdown;reboot;logout)

            modules-left = [ "sway/workspaces" "sway/window" ];
            modules-center = [ "clock" ];
            modules-right = [  "pulseaudio" "network" "bluetooth" "battery" ];

            /* Show the sway workspaces in your waybar */
            "sway/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
              disable-click = true;

              format = "{name}";
            };

            /* Show the Active Window without icons */
            "sway/window" = {
              all-outputs = true;

              icon = true;
              icon-size = 18;

              format = "| {title}";
              max-length = 36;
            };

            /*
             * Show the current connected Bluetooth devices
             * Enable: sylveon.hardware.bluetooth
             */
            "bluetooth" = {
              format = " {status}";
              format-disabled = ""; # Disables the module if bluetooth is not available
              format-on = "";

              format-connected = " {device_alias}";
              format-connected-battery = " {device_alias} {device_battery_percantage}%"; # Needs bluetooth expirmental
              on-click = "exec ${pkgs.blueman}/bin/blueman-manager";
            };



            /* Show the current audio device with icons and change the volume by scrolling */
            "pulseaudio" = {
              format = "{icon} {volume}%";
              format-muted = " ";
              on-click = "pavucontrol";

              states.muted = 0;
              
              tooltip-format = "Device: {desc}";

              format-icons = {
                default = [ " " " " " " ];
                muted = " ";
              };
            };

            /* Show the current network type; If the connection is LAN, show bandwith status with IP adress */
            "network" = {
              interval = 10;
              format-wifi = "{icon}";
              format-disconnected = "󰖪";
              format-ethernet = "󰌗";

              tooltip-format-wifi = "{essid} {signalStrength}%";
              tooltip-format-ethernet = "{ipaddr}";

              format-icons = [ "󰤟" "󰤢" "󰤥" "󰤨" ];

            };

            /* The Battery status will be shown */
            "battery" = {
              interval = 1;
              full-at = 80; # Changed in BIOS for a better capacity

              states = {
                full = 100;
                not-fully-full = 99;
                warning = 40;
                critical = 20;

              };

              tooltip-format = "Watt usage: {power} \nCapacity: {capacity}% /time remain: {time} \nBattery cycles: {cycles}";

              format = "{icon}";
              format-plugged = "{icon}";

              format-warning = ""; # change color to orange
              format-critical = ""; # change color to red
              format-full = "󰁹󰋑";


              format-icons = { 
                discharging = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" ];
                charging = [ "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊"  ];
              };
            };


            /* Show the current time (change formating here...) */
            "clock" = {
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
