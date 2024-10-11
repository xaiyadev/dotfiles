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
  host,

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

      /* Desktop Environment */
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

      /* Sway configuration */
      wayland.windowManager.sway = {
        enable = true;
        checkConfig = false;

        config = {
          menu = "${pkgs.wofi}/bin/wofi --allow-images --show drun";
          bars = [ ];

          output = {
            "*" = {
              bg = "~/.config/wallpapers/something-beautiful-in-nature.jpg fill";
            };

            "eDP-1" = {
              pos = "0 227";
            };

            "DP-1" =  {
              pos = "4480 0";
            };

            "HDMI-A-1" = if host == "pineapple" then {
              pos = "1920 0";
            } else {
              pos = "5760 0";
            };

            "DP-2" = {
              pos = "3840 0";
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
          terminal = "kitty";

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

          keybindings = let modifier = config.wayland.windowManager.sway.config.modifier;
          in lib.mkOptionDefault {
              "${modifier}+e" = "exec ${pkgs.wofi-emoji}/bin/wofi-emoji";
              "${modifier}+l" = "exec ${pkgs.swaylock-effects}/bin/swaylock";
          };

        };
	      extraConfig = ''exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK '';
      };


      /* Swaylock configuration */
      programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;

        settings = {
          ignore-empty-password = true;
          font = "JetBrainsMono Nerd Font";

          /* Colors in this theme inspired from https://rosepinetheme.com/ */
          color = "#1f1d2e";
          text-color = "#e0def4";
          indicator = true;


          inside-color = "#26233a";
          inside-caps-lock-color = "#26233a";
          inside-ver-color = "#26233a";
          inside-wrong-color = "#26233a";
          inside-clear-color = "#26233a";

          key-hl-color = "#9ccfd8";
          ring-color = "#403d52";
          ring-clear-color = "#eb6f92";
          ring-caps-lock-color = "#eb6f92";
          ring-ver-color = "#31748f";
          ring-wrong-color = "#eb6f92";


          indicator-radius = 100;
          indicator-thickness = 5;

          /*
           * Swaylock Effects Settings
           * remove this if you use swaylock from the terminal
           */

          effect-blur = "7x5";
          effect-vignette = "0.8:0.8";

          grace = 2;

          screenshots = true;
          clock = true;
        };
      };



      ${namespace} = {
        tools.kitty.enable = true;
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
