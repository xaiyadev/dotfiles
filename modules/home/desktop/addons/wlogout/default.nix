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
    cfg = config.${namespace}.desktop.addons.wlogout;
in
{
    options.${namespace}.desktop.addons.wlogout = {
        enable = mkBoolOpt false "Stop reboot or logout of the system, in a simple way";
    };

    config = mkIf cfg.enable {
      programs.wlogout = {
        enable = true;

        layout = [
          {
            label = "shutdown";
            action = "${pkgs.systemd}/bin/systemctl poweroff";
            text = "Shutdown";
            keybind = "s";
          }

          {
            label = "reboot";
            action = "${pkgs.systemd}/bin/systemctl reboot";
            text = "Reboot";
            keybind = "r";
          }

          {
            label = "logout";
            action = "${pkgs.systemd}/bin/loginctl kill-session $XDG_SESSION_ID";
            text = "Logout";
            keybind = "e";
          }

          {
            label = "lock";
            action = "${pkgs.swaylock-effects}/bin/swaylock";
            text = "Lock";
            keybind = "l";
          }

          {
            label = "switch_gnome";
            action = "echo 'blub'";
            text = "Switch to Gnome";
          }

          {
            label = "switch_windows";
            action = "echo 'blub'";
            text = "Switch to Windows";
          }
        ];

        style = strings.concatStrings [
          # Default CSS
          (builtins.readFile ./style/index.css)

          # Import Icons
          ''
          #lock { background-image: url("${./icons/lock_light.png}") }
          #logout { background-image: url("${./icons/logout_light.png}") }
          #reboot { background-image: url("${./icons/reboot_light.png}") }
          #shutdown { background-image: url("${./icons/shutdown_light.png}") }
          #switch_windows { background-image: url("${./icons/windows.png}") }
          #switch_gnome { background-image: url("${./icons/gnome.png}") }
          ''

         ];
      };
    };
}