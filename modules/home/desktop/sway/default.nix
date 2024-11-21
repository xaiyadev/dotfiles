{
  lib,
  pkgs,
  inputs,

  namespace,
  target,
  format,
  virtual,
  host,

  config,
  osConfig,
  ...
}:
with lib;
with lib.${namespace};
let
  modifier = "Mod4";
in {

  # This configuration will only be enabled when the nixOS modules is enabled
  # This helps with visibility and keeps them in one
  config = mkIf osConfig.${namespace}.desktop.sway.enable {

    /* Install all nesecerry addons */
    ${namespace}.desktop.addons = {
      kanshi.enable = true;
    };

    wayland.windowManager.sway = {
      enable = true;
      checkConfig = false;

      config = {
        # Default Configurations
        menu = "${pkgs.wofi}/bin/wofi --allow-images --show drun";
        bars = [ { command = "${pkgs.waybar}/bin/waybar"; }];

        modifier = modifier;
        terminal = "kitty";

        # Outputs managed by kanshi

        # Windows
        defaultWorkspace = "1";
        window = { border = 4; titlebar = false; };
        gaps = { inner = 15; };

        colors = { # Rose Pine color theme
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

        # Devices/INputs
        input = {
          "*" = {
            xkb_layout = "de";
            accel_profile = "flat";
            pointer_accel = "-0.6";
          };

          "2:14:ETPS/2_Elantech_Touchpad" = { pointer_accel = "0"; natural_scroll = "enabled"; };
        };

        keybindings = mkOptionDefault {
          "${modifier}+e" = "exec ${pkgs.wofi-emoji}/bin/wofi-emoji";
          "${modifier}+l" = "exec ${pkgs.swaylock-effects}/bin/swaylock"; # TODO: change to systemctl command
          "${modifier}+Escape" = "exec ${pkgs.wlogout}/bin/wlogout";
        };

        startup = [
          { command = ''exec spotify''; }
          { command = ''sleep 5 && sway '[class="Spotify"]' move container to workspace 4 ''; }

          { command = ''exec vesktop''; }
          { command = ''sleep 5 && sway '[class="vesktop"]' move container to workspace 5''; }
        ];

        # Maybe need extra config to name workspaces?
      };
    };
  };
}
