{
  lib,
  pkgs,
  inputs,

  namespace,
  target,
  format,
  virtual,
  host,

  osConfig,
  config,
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
    home.file.".config/wallpapers/" = { source = ./wallpapers; recursive = true; };

    /* Install all nesecerry addons */
    ${namespace}.desktop.addons = {
      kanshi = enabled;

      waybar = enabled;
      wofi = enabled;
      swaylock = enabled;
      wlogout = enabled;

      gtk = enabled;
      keyring = enabled;
    };

    wayland.windowManager.sway = {
      enable = true;
      package = null;
      checkConfig = false;

      # Adds a systemd target, for tools like kanshi to work
      systemd = {
        enable = true;
        xdgAutostart = true;
      };

      config = {
        # Default Configurations
        menu = "${pkgs.wofi}/bin/wofi --allow-images --show drun";
        bars = [ { command = "${pkgs.waybar}/bin/waybar"; }];

        modifier = modifier;
        terminal = "${config.programs.kitty.package}/bin/kitty";

        # Outputs managed by kanshi
        defaultWorkspace = "workspace number 1";
        workspaceOutputAssign = [
        { 
          output = [ "Philips Consumer Electronics Company PHL 272B4Q AU11526001821" "eDP-1" ]; 
          workspace = "workspace number 1"; 
        }
        
        { output = "eDP-1"; workspace = "workspace number 3"; }
        { output = "eDP-1"; workspace = "workspace number 4"; }
        { output = "eDP-1"; workspace = "workspace number 5"; }
        ];
        output = { "*" = { bg = "~/.config/wallpapers/girls.jpeg fill"; }; };

        # Windows
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
          "${modifier}+l" = "exec ${pkgs.swaylock-effects}/bin/swaylock";
          "${modifier}+Escape" = "exec ${pkgs.wlogout}/bin/wlogout";
        };

        # Maybe need extra config to name workspaces?
      };
    };
  };
}
