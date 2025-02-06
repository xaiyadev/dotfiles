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

    /* Install all nesecerry addons */
    ${namespace}.desktop.addons = {
      kanshi = enabled;

      waybar = enabled;
      wofi = enabled;
      swaylock = enabled;
      wlogout = enabled;
      swaync = enabled;

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
        bars = [ { command = "${pkgs.waybar}/bin/waybar"; }];

        modifier = modifier;
        terminal = "${pkgs.kitty}/bin/kitty";

        # Outputs managed by kanshi
        defaultWorkspace = "1";
        workspaceOutputAssign = [
          { 
            output = [ "Philips Consumer Electronics Company PHL 272B4Q AU11526001821" "eDP-2" ];
            workspace = "1"; 
          }

          { 
            output = "Philips Consumer Electronics Company PHL 272B4Q AU11531001040";
            workspace = "2"; 
          }
          
          { output = "eDP-2"; workspace = "3"; }
          { output = "eDP-2"; workspace = "4"; }
          { output = "eDP-2"; workspace = "5"; }
        ];

        # Windows
        window = { border = 2; titlebar = false; };
        gaps = { inner = 5; };

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
            pointer_accel = "-0.7";
          };

          "2362:628:PIXA3854:00_093A:0274_Touchpad" = { 
            pointer_accel = "0.2";
            natural_scroll = "enabled"; 

            dwt = "enabled";
            tap = "enabled";
            middle_emulation = "enabled";
          };
        };

        keybindings = mkOptionDefault {
          "${modifier}+e" = "exec ${pkgs.wofi-emoji}/bin/wofi-emoji";
          "${modifier}+shift+Escape" = "exec ${pkgs.swaylock-effects}/bin/swaylock";
          "${modifier}+Escape" = "exec ${pkgs.wlogout}/bin/wlogout";
        };
      };

      # Extra stuff that cant be handled with sway (whyy??)
      extraConfig = ''
        exec ${pkgs.swaybg}/bin/swaybg -o "*" -i ${./wallpapers/street-girl-lookingout.jpg} -m fill
      '';

    };
  };
}
