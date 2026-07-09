{
  osConfig,
  lib,
  pkgs,
  config,
  self,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOptionDefault
    concatStringsSep
    getExe
    mkMerge
    forEach
    elemAt
    ;

  modifier = "Mod4";
  inherit (osConfig.sylveon.graphical) sway;

in
{
  imports = [
    ./waybar # Title bar TODO: replace with eww?
    ./kanshi # Window/Output manager
    ./quickshell
  ];

  config = mkIf sway.enable {
    wayland.windowManager.sway = {
      enable = true;

      # Package is set to null because it is already created in the original config
      package = null;

      systemd = {
        enable = true;
        xdgAutostart = true;
      };

      config = {
        inherit modifier;
        terminal = "${getExe config.programs.kitty.package}";
        defaultWorkspace = "1";

        menu = "${getExe config.programs.vicinae.package} toggle";

        output."*" = {
          bg = "${self}/assets/wallpaper/current.png fill";
        };

        colors =
          let
            submodule = {
              childBorder = "$base";
              indicator = submodule.childBorder;

              # Configuration needed only if using the title bar
              text = "$text";
              border = submodule.childBorder;
              background = "$base";
            };
          in
          {
            focused = submodule // rec {
              childBorder = "\$${config.catppuccin.accent}";
              indicator = childBorder;
              border = childBorder;
            };

            urgent = submodule // rec {
              childBorder = "$red";
              indicator = childBorder;
              border = childBorder;
            };

            placeholder = submodule;
            focusedInactive = submodule;
            unfocused = submodule;
          };

        input = {
          "*" = {
            xkb_layout = "de";

            accel_profile = "flat";
            pointer_accel = "-0.7";
          };

          # Framework 16 touchpad
          "2362:628:PIXA3854:00_093A:0274_Touchpad" = {
            pointer_accel = "-0.2";
            natural_scroll = "enabled";
            # Disable while typing could annoy some people while gaming
            dwt = "enabled";
          };
        };

        workspaceOutputAssign = mkMerge [
          # Automaticly generated configuration based on kanshi
          (mkIf config.services.kanshi.enable (
            forEach [ 1 2 ] (x: {
              output = forEach config.services.kanshi.settings (y: (elemAt y.profile.outputs (x - 1)).criteria);

              # Assign the 10 workspaces we have
              workspace = toString x;
            })
          ))

          # default assigned workspaces
          [
            {
              output = [ "eDP-2" ];
              workspace = "3";
            }

            {
              output = [ "eDP-2" ];
              workspace = "4";
            }
          ]
        ];

        window = {
          border = 3;
          titlebar = false;
        };

        gaps = {
          inner = 8;
          outer = 3;
        };

        floating = {
          # Windows that should be opened in floating mode
          criteria = [
            # Configuration apps
            { class = "Enpass"; }
            { app_id = "com.yubico.yubioath"; }

            # Settings apps
            { app_id = ".blueman-manager-wrapped"; }
            { app_id = "org.pulseaudio.pavucontrol"; }
          ];
        };

        assigns = {
          # Assign social apps to workspace 4
          "4" = [
            { class = "discord"; }
            { class = "teams-for-linux"; }
          ];
        };

        startup = [
          # Display and configurations
          {
            command = getExe pkgs.kanshi;
            always = true;
          }

          # Background Services
          { command = getExe pkgs.sway-audio-idle-inhibit; }
          { command = "${getExe config.programs.vicinae.package} server"; }
        ];

        keybindings = mkOptionDefault {
          "${modifier}+Escape" = "exec ${getExe config.programs.swaylock.package}";

          "${modifier}+shift+s" =
            ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | ${pkgs.wl-clipboard}/bin/wl-copy''; # Take a screenshot

          "${modifier}+e" = "exec ${pkgs.nemo-with-extensions}/bin/nemo";
          "${modifier}+o" = "exec ${getExe pkgs.obsidian}";

          "${modifier}+shift+v" =
            "exec ${getExe config.programs.vicinae.package} deeplink vicinae://extensions/vicinae/clipboard/history";
        };
      };

      # SwayFx specific configuration
      extraConfig = concatStringsSep "\n" [
        # Shadows
        "shadows enable"
        "shadows_on_csd enable"

        "shadow_color #7c7f93"
        "shadow_inactive_color #7c7f93"

        # "shadow_offset 5 5"
        "shadow_blur_radius 10"

        # Corners
        "corner_radius 13"
      ];
    };

    # Extra packages needed by sway
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;

      settings = {
        effect-blur = "13x13";
        effect-vignette = "0.4:0.4";

        grace = 5; # Time until you can still exit the lock screen without a password
        grace-no-mouse = true;

        screenshots = true;

        clock = false;
      };
    };

    services = {
      swaync = {
        enable = true;

        settings = {
          positionX = "right";
          positionY = "top";

          image-visibility = "never";
        };
      };

      swayidle = {
        enable = true;

        timeouts = [
          {
            timeout = 300;
            command = "exec ${config.programs.swaylock.package}/bin/swaylock";
          }
        ];

        events."before-sleep" = "exec ${config.programs.swaylock.package}/bin/swaylock";
      };
    };
  };
}
