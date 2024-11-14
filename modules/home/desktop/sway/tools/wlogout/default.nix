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
    cfg = config.${namespace}.desktop.config.sway.tools.wlogout;
in
{
    options.${namespace}.desktop.config.sway.tools.wlogout = {
        enable = mkEnableOption "Stop reboot or logout of the system, in a simple way";
    };

    config = mkIf cfg.enable {
      programs.wlogout = {
        enable = true;

        layout = [
          {
              label = "shutdown";
              action = "systemctl poweroff";
              text = "Shutdown";
              keybind = "s";
          }
        {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
        }
        {
            label = "logout";
            action = "loginctl kill-session $XDG_SESSION_ID";
            text = "Logout";
            keybind = "e";
        }
        {
            label = "hibernate";
            action = "swaylock -f && systemctl hibernate";
            text = "Hibernate";
            keybind = "h";
        }

        {
            label = "lock";
            action = "swaylock -f";
            text = "Lock";
            keybind = "l";
        }

        ];
      };
    };
}