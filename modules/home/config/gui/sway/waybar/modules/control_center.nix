{ pkgs, lib, ... }:
let
  inherit (lib) getExe;
in
{
  programs.waybar.settings.mainBar = {

    "bluetooth" = {
      interval = 3;
      format-on = " {status}";
      format-disabled = "󰂲 {status}";
      format-connected = "󰂱 {device_alias} {device_battery_percentage}%";

      on-click = "exec ${getExe pkgs.overskride}";
    };

    # Show the current audio device with icons and change the volume by scrolling
    "pulseaudio" = {
      format = "{icon} {volume}%";
      on-click = "${getExe pkgs.pavucontrol}";

      format-icons = [ " " ];
    };
  };
}
