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
    cfg = config.${namespace}.tools.alacritty;
in
{
    options.${namespace}.tools.alacritty = {
        enable = mkEnableOption "setup alacritty, a terminal I only use in sway!";
    };

    config = mkIf cfg.enable {
      programs.alacritty = {
        enable = true;

        settings = {
          env = {
            TERM = "alacritty";
          };

          window = {
            padding = {
              x = 20;
              y = 20;
            };

	    opacity = 0.9;
          };

          scrolling = {
            history = 10000;
            multiplier = 3;
          };

          font = {
            normal = {
              family = "JetBrains Mono";
              style = "Regular";
            };

          size = 11;
          };

          colors = {
            primary = {
              background = "#111111";
              foreground = "#ffffff";
            };

            cursor = {
              text = "CellBackground";
              cursor = "CellForeground";
            };

            vi_mode_cursor = {
              text = "CellBackground";
              cursor = "CellForeground";
            };

            normal = {
              black = "#111111";
              red = "#d40b0e";
              green = "#52ff80";
              yellow = "#fff642";
              blue = "#1a93c7";
              magenta = "#db1d00";
              cyan = "#5ae8e1";
              white = "#ffffff";
            };

            transparent_background_colors = true;
          };

          live_config_reload = true;

          debug = {
            render_timer = false;
            persistent_logging = false;
            log_level = "Warn";
            print_events = false;
          };
        };
      };
    };
}
