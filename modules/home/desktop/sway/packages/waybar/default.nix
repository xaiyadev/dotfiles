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

  home.packages = [ pkgs.playerctl ];
  programs.waybar = {
    enable = builtins.elem "sway" windowManagers;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;

        margin-top = 5;
        margin-left = 5;
        margin-right = 5;

        margin-bottom = 3;

        /* Enable modules in the right positions */

        modules-left = [ "image#nix_trans" "sway/workspaces" ];
        modules-right = [ "mpris" "pulseaudio" "network" "bluetooth" "battery" "tray" "clock" ];

        "image#nix_trans" = {
          path = "${./lix.svg}";
          size = 20;
        };

        /* Show the sway workspaces in your waybar */
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;

          format = "{icon}";

          format-icons = {
            "1" = " ";
            "2" = " ";
            "3" = " ";
            "4" = "󰕘 ";
            "5" = "󱝁 ";
            "6" = " ";
            "7" = " ";
            "8" = " ";
            "9" = "󱕅 ";
            "10" = " ";
            sort-by-number = true;
          };
        };

        "bluetooth" = {
          interval = 3;
          format-on = "";
          format-disabled = "󰂲";
          format-connected = "󰂱 {device_alias} {device_battery_percentage}%";

          on-click = "exec ${pkgs.blueman}/bin/blueman-manager";
        };

        "tray" = {
          spacing = 10;
          icon-size = 18;
          show-passive-items = true;
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
          max-length = 30;

          format-wifi = "{icon} {essid}";
          format-ethernet = "󰌗 ";

          format-icons = [ "󰤟 " "󰤢 " "󰤥 " "󰤨 " ];

        };

        /* The Battery status will be shown */
        "battery" = {
          interval = 10;
          full-at = 80; # Changed in BIOS for better capacity

          tooltip-format = "Watt usage: {power} \nCapacity: {capacity}% /time remain: {time} \nBattery cycles: {cycles}";

          format = "{icon} {capacity}%";
          format-charging = " {icon} {capacity}%";
          format-full = "󰚥";

          format-icons = [ "󱟩" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹" ];
        };

        /* Show the current time (change formating here...) */
        "clock" = {
          interval = 60;

          timezone = "Europe/Berlin";
          locale = "de_DE.UTF-8";
          format = "󱑅  {:%H:%M}";
        };

        "mpris" = {
          interval = 1;
          max-length = 80;

        	format = "{player_icon} <i>{position}/{length}</i>";
          format-paused = "{status_icon} <i>{position}/{length}</i>";

        	player-icons = {
        	  default = " ";
        	  firefox = " "; # Librewolf is based on firefox
        	  chromium = "󰤺 "; # TIDAL-HIFI is based on chromium, so will use that
        	};

        	status-icons.paused = " ";
        };
      };
    };



    style = builtins.readFile ./style.css;

  };
}