{ pkgs, osConfig, lib, ... }:
let
  inherit (lib) mkIf;

  windowManagers = osConfig.sylveon.system.graphical.windowManagers;
in
{

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
        height = 40;

        margin-top = 6;
        margin-bottom = 3;
        margin-left = 5;
        margin-right = 5;

        /* Enable modules in the right positions */

        modules-left = [ "sway/workspaces" "sway/window" ];
        modules-center = [ "clock" ];
        modules-right = [  "pulseaudio" "network" "bluetooth" "battery" "custom/wlogout" ];

        /* Show the sway workspaces in your waybar */
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          disable-click = true;

          format = "{name}";
          format-window-separator = " | ";
        };

        /* Show the Active Window without icons */
        "sway/window" = {
          all-outputs = true;

          icon = false;
          icon-size = 18;

          format = "{title}";
          max-length = 36;
        };

        "bluetooth" = {
          format = " {status} |";
          format-disabled = "󰂲 |";
          format-on = " |";

          format-connected = " {device_alias} |";
          format-connected-battery = " {device_alias} 󰥈 {device_battery_percentage}% |";

          tooltip-format = "Device:\nAddress: {device_address} / Type: {device_address_type}\nController:\nAddress: {controller_address} / Type: {controller_address_type}";

          on-click = "exec ${pkgs.blueman}/bin/blueman-manager";
        };



        /* Show the current audio device with icons and change the volume by scrolling */
        "pulseaudio" = {
          format = "{icon} {volume}% |";
          on-click = "pavucontrol";

          states.muted = 0;
          format-muted = " {volume}%|";

          tooltip-format = "Device: {desc}";

          format-icons = [ "" " " ];
        };

        /* Show the current network type; If the connection is LAN, show bandwith status with IP adress */
        "network" = {
          interval = 3;
          max-length = 25;

          format-wifi = "{icon}";
          format-disconnected = " 󰖪 ";
          format-ethernet = "󰌗   {bandwidthDownBits}";

          tooltip-format = "\nNetwork (WIFI): {essid} 󰢾 {signalStrength}% \nInterface: {ifname}\nIP-Adress: {ipaddr}\nDownload/Upload Speed:  {bandwidthDownBits}  {bandwidthUpBits}";

          format-icons = [ "󰤟 " "󰤢 " "󰤥 " "󰤨 " ];

        };

        /* The Battery status will be shown */
        "battery" = {
          interval = 1;
          full-at = 80; # Changed in BIOS for better capacity

          states = {
            full = 100;
            not-fully-full = 99;
            warning = 40;
            critical = 20;

          };

          tooltip-format = "Watt usage: {power} \nCapacity: {capacity}% /time remain: {time} \nBattery cycles: {cycles}";

          format = "{icon} {capacity}% |";
          format-plugged = "{icon} {capacity}% |";
          format-not-fully-full = "{icon} {capacity}% |";

          #format-warning = ""; # change color to orange
          #format-critical = ""; # change color to red
          format-full = "󱟢 |";


          format-icons = {
            discharging = [ "󱟩" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹" ];
            charging = [ "󱟩" "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰁹" ];
          };
        };

        /* Show the current time (change formating here...) */
        "clock" = {
          interval = 60;

          timezone = "Europe/Berlin";
          locale = "de_DE.UTF-8";
          format = "{:%H:%M}";
        };

      };
    };

    style = builtins.readFile ./style.css;

  };
}