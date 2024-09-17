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
    options.${namespace}.desktop.config.sway = {
        enable = mkEnableOption "Setup sway settings!";
    };

    config = mkIf cfg.enable {
      home.file.".config/wallpapers/something-beautiful-in-nature.jpg".source = ./wallpapers/something-beautiful-in-nature.jpg;

      home.packages = with pkgs; [
          (pkgs.python3Full.withPackages (python-pkgs: [
            python-pkgs.pygobject3
            python-pkgs.gst-python
            pkgs.playerctl
          ]))
      ];
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config.common = {
          default = [
            "gtk"
            "wlr"
          ];
        };
      };

      wayland.windowManager.sway = {
        enable = true;
        checkConfig = false;

        config = {
          menu = "${pkgs.wofi}/bin/wofi --show run";
          bars = [ ];

          output = {
            "*" = {
              bg = "~/.config/wallpapers/something-beautiful-in-nature.jpg fill";
            };

            # Laptop Setup
            "eDP-1" = {
              pos = "0 227";
            };
            "DP-1" = {
              pos = "4480 0";
            };
            "HDMI-A-1" = {
              pos = "1920 0";
            };

          };

          input = {
            "*" = {
              xkb_layout = "de";
              accel_profile = "flat";
              pointer_accel = "-0.6";
            };

            /* Laptop Touchpad */
            "2:14:ETPS/2_Elantech_Touchpad" = {
              pointer_accel = "0";
              natural_scroll = "enabled";
            };
          };

          modifier = "Mod4";
          terminal = "alacritty";

          window = {
            border = 4;
            titlebar = false;
          };

          gaps = {
            inner = 15;

          };

          colors = {
            # Rose Pine color theme
            focused = {
              background = "#31748f";
              border = "#ebbcba";
              childBorder = "#ebbcba";
              text = "#e0def4";
              indicator = "#ebbcba";
            };
            
            unfocused = {
              background = "#9ccfd8";
              border = "#6e6a86";
              childBorder = "#6e6a86";
              text = "#e0def4";
              indicator = "#6e6a86";
            };
          };
        };
	      extraConfig = ''exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK '';
      };

      ${namespace} = {
        tools.alacritty.enable = true;
        desktop.config = {
          gnome = {
            enable = true;
            dconf = false;
          };

          sway.tools = {
            waybar.enable = true;
            wofi.enable = true;
          };

        };
      };
    };
}
