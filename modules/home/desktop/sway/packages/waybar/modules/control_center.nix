{ pkgs, ... }:
{
  programs.waybar.settings.mainBar = {

    "bluetooth" = {
      interval = 3;
      format-on = " {status}";
      format-disabled = "󰂲 {status}";
      format-connected = "󰂱 {device_alias} {device_battery_percentage}%";

      on-click = "exec ${pkgs.blueman}/bin/blueman-manager";
    };

    # Show the current audio device with icons and change the volume by scrolling
    "pulseaudio" = {
      format = "{icon} {volume}%";
      on-click = "${pkgs.pavucontrol}/bin/pavucontrol";

      format-icons = [ " " ];
    };

    # Show the current network type; If the connection is LAN, show bandwith status with IP adress
    "network" = {
      interval = 3;
      max-length = 30;

      format-wifi = "{icon} {essid}";
      format-ethernet = "󰌗 ";

      format-icons = [
        "󰤟 "
        "󰤢 "
        "󰤥 "
        "󰤨 "
      ];

    };

  };
}
