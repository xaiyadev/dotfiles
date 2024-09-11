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
    cfg = config.${namespace}.desktop.config.sway;
in
{
    options.${namespace}.tools.waybar = {
        enable = mkEnableOption "Setup Waybar!";
    };

    config = mkIf cfg.enable {
      programs.waybar = {
        enable = true;
        systemd.enable = true;

        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 26;
            # TODO: output

            modules-left = [ "custom/logo" "sway/workspaces" ];
            modules-center = [ "clock" ];
            modules-right = [ "battery" ];

            "custom/logo" = {
              format = "🎉";
              tooltip = false;
              on-click = ''bemenu-run --accept-single  -n -p "Launch" --hp 4 --hf "#ffffff" --sf "#ffffff" --tf "#ffffff" '';
            };

            "sway/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
              disable-click = true;
            };

            "clock" = {
              interval = 60;
              format = "{:%a %d/%m %I:%M}";
            };

            "battery" = {
              tooltip = false;
              format = "{icon} {capacity}% // Time left: {time}";
              format-icons = [ "🍎⚠️" "🌻" "🍃" ];
            };
          };
        };

      };
    };
}