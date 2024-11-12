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
      /*home.file.".config/wallpapers/something-beautiful-in-nature.jpg".source = ./wallpapers/something-beautiful-in-nature.jpg;*/
      home.file.".config/wallpapers/girls.jpeg".source = ./wallpapers/girls.jpeg;

      home.packages = with pkgs; [
        wl-clipboard # copy and paste in wayland
        # Screenshot utilitis
        grim
        slurp
      ];

      /* Sway configuration */
      wayland.windowManager.sway = {
        enable = true;
        package = pkgs.sway;
        checkConfig = false;
        extraOptions = [ "--unsupported-gpu" ];

        config = {
          menu = "${pkgs.wofi}/bin/wofi --allow-images --show drun";
          bars = [ { command = "${pkgs.waybar}/bin/waybar"; } ];
          modifier = "Mod4";
          terminal = "kitty";

          output = {
            "*" = {
              /*bg = "~/.config/wallpapers/something-beautiful-in-nature.jpg fill";*/
              bg = "~/.config/wallpapers/girls.jpeg fill";
            };

            "eDP-1" = {
              pos = "0 227";
            };

            "DP-1" =  {
              pos = "4480 0";
            };

            "HDMI-A-1" = {
              pos = "1920 0";
              mode = "1920x1080@119.982Hz";
              };

            "DP-3" = {
              pos = "0 0";
            };

          };

          defaultWorkspace = "1";
          workspaceOutputAssign = [
            {
              output = "HDMI-A-1";
              workspace = "1";
            }
            {
              output = "DP-3";
              workspace = "2";
            }
            {
              output = "DP-1";
              workspace = "2";
            }
            {
              output = "eDP-1";
              workspace = "3";
            }
          ];

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

          keybindings = let modifier = config.wayland.windowManager.sway.config.modifier;
          in lib.mkOptionDefault {
              "${modifier}+e" = "exec ${pkgs.wofi-emoji}/bin/wofi-emoji";
              "${modifier}+l" = "exec ${pkgs.swaylock-effects}/bin/swaylock";
              "${modifier}+Escape" = "exec ${pkgs.wlogout}/bin/wlogout";
          };

          startup = [
            { command = ''exec spotify''; }
            { command = ''sleep 5 && sway '[class="Spotify"]' move container to workspace 4 ''; }

            { command = ''exec vesktop''; }
            { command = ''sleep 5 && sway '[class="vesktop"]' move container to workspace 5''; }
          ];

        };

	      extraConfig = ''
          # Activate dbus for starting programs faster
          exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK

          # Set the names of the workspaces -> already managed in Waybar but for workspace managment in sway needed
          set $ws1 1
          set $ws2 2
          set $ws3 3
          set $ws4 4
          set $ws5 5
          set $ws6 6
          set $ws7 7
          set $ws8 8
          set $ws9 9
          set $ws0 0
	      '';
      };

      ${namespace} = {
        tools.kitty.enable = true;

        desktop.config = {
          sway.tools = {
            waybar.enable = true;
            wofi.enable = true;
            wlogout.enable = true;
            swaylock.enable = true;
          };

        };
      };
    };
}
