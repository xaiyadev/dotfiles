{ pkgs, osConfig, lib, config, ... }:
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

        modules-left = [ "sway/workspaces" ];
        modules-center = [ "custom/swaync" "sway/window" /* Music */ ];
        modules-right = [  "pulseaudio" "network" "bluetooth" "battery" "clock" ];

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

          icon = false;
          icon-size = 18;

          format = "{title}";
          max-length = 36;
        };

        "bluetooth" = {
          format = " {status}";
          format-disabled = "󰂲";
          format-on = "";

          format-connected = "{device_alias} ";

          tooltip-format = "Device:\nAddress: {device_address} / Type: {device_address_type}\nController:\nAddress: {controller_address} / Type: {controller_address_type}";

          on-click = "exec ${pkgs.blueman}/bin/blueman-manager";
        };



        /* Show the current audio device with icons and change the volume by scrolling */
        "pulseaudio" = {
          format = "{icon} {volume}%";
          on-click = "pavucontrol";

          states.muted = 0;
          format-muted = "  {volume}%";

          tooltip-format = "Device: {desc}";

          format-icons = [ "" " " ];
        };

        /* Show the current network type; If the connection is LAN, show bandwith status with IP adress */
        "network" = {
          interval = 3;
          max-length = 50;


          format-wifi = "{essid} {icon}";
          format-ethernet = "󰌗  {bandwidthDownBits}";

          tooltip-format = "\nNetwork (WIFI): {essid} 󰢾 {signalStrength}% \nInterface: {ifname}\nIP-Adress: {ipaddr}\nDownload/Upload Speed:  {bandwidthDownBits}  {bandwidthUpBits}";

          format-icons = [ "󰤟" "󰤢" "󰤥" "󰤨" ];

        };

        /* The Battery status will be shown */
        "battery" = {
          interval = 1;
          full-at = 80; # Changed in BIOS for better capacity

          tooltip-format = "Watt usage: {power} \nCapacity: {capacity}% /time remain: {time} \nBattery cycles: {cycles}";

          format = "{icon} {capacity}%";

          format-icons = {
            discharging = [ "󱟩" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹" ];
            charging = [ "󱟩" "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰁹" ];
            default = "󰁹";
          };
        };

        /* Show the current time (change formating here...) */
        "clock" = {
          interval = 60;

          timezone = "Europe/Berlin";
          locale = "de_DE.UTF-8";
          format = "{:%H:%M}";
        };

        "custom/swaync" = mkIf config.services.swaync.enable {
          tooltip = false;

          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup>󰂚 </sup></span>";
            none = "󰂚";
            dnd-notification = "<span foreground='red'><sup>󰂠 </sup></span>";
            dnd-none = "󰂠";
            inhibited-notification = "<span foreground='red'><sup>󰂚 </sup></span>";
            inhibited-none = "󰂚";
            dnd-inhibited-notification = "<span foreground='red'><sup>󰂠 </sup></span>";
            dnd-inhibited-none = "󰂠";
          };

          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

      };
    };

    style = builtins.readFile ./style.css;

  };
}