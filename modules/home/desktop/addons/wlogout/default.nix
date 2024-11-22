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
            label = "hibernate";
            action = "${pkgs.systemd}/bin/systemctl suspend";
            text = "Hibernate";
            keybind = "h";
          }

          {
            label = "lock";
            action = "${pkgs.swaylock-effects}/bin/swaylock";
            text = "Lock";
            keybind = "l";
          }
        ];

        # TODO: add CSS configurations for that
      };
    };
}