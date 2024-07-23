{ config, lib, ... }:
with lib;
let
    cfg = config.services.gnome-config;
in
{
    options.services.gnome-config = {
        enable = mkEnableOption "custom gnome home-manager config service";

        favorite-apps = mkOption {
            type = types.listOf types.str;
            default =  [
                "chromium.desktop"
                "vesktop.desktop"
                "spotify.desktop"
            ];
        };

        wallpaper = mkOption {
            type = types.str;
            default =  "file:///home/semiko/.config/nixos/wallpapers/wallpaper-1.png";
        };
    };

    config = mkIf cfg.enable {
              dconf = {
                  enable = true;
                  settings."org/gnome/desktop/background".picture-ui = cfg.wallpaper;

                  settings."org/gnome/desktop/wm/preferences" = {
                      audible-bell = false;
                      button-layout = ":minimize,maximize,close";
                  };

                  settings."org/gnome/desktop/interface" = {
                      color-scheme = "prefer-dark";
                      clock-format = "24h";
                      show-battery-percentage = true;
                  };

                  settings."org/gnome/shell" = {
                      favorite-apps = cfg.favorite-apps;

                      enabled-extensions = [
                          "weatheroclock@CleoMenezesJr.github.io"
                          "appindicatorsupport@rgcjonas.gmail.com"
                          "sp-tray@sp-tray.esenliyim.github.com"
                          "dash-to-dock@micxgx.gmail.com"
                           "blur-my-shell@aunetx"
                           "user-theme@gnome-shell-extensions.gcampax.github.com"
                      ];
                  };

                  /* --- Extension Settings --- */
                  # TODO: Pipeline needs a fix, only can give string, does not want a string :(
                  settings."org/gnome/shell/extensions/blur-my-shell".pipelines = ''{'pipeline_default': {'name': <'Default'>, 'effects': <[<{'type': <'native_static_gaussian_blur'>, 'id': <'effect_000000000000'>, 'params': <{'radius': <30>, 'brightness': <1>, 'unscaled_radius': <50>}>}>, <{'type': <'corner'>, 'id': <'effect_02185216467698'>, 'params': <@a{sv} {}>}>]>}, 'pipeline_default_rounded': {'name': <'Default rounded'>, 'effects': <[<{'type': <'native_static_gaussian_blur'>, 'id': <'effect_000000000001'>, 'params': <{'radius': <30>, 'brightness': <0.59999999999999998>}>}>, <{'type': <'corner'>, 'id': <'effect_000000000002'>, 'params': <{'radius': <24>}>}>]>}} '';

                  settings."org/gnome/shell/extensions/blur-my-shell/appfolder" = {
                      brightness = 1;
                      sigma = 20;
                  };

                  settings."org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
                      blur = true;
                      brightness = 1;
                      override-background = true;
                      pipeline = "pipeline_default";
                      sigma = 40;
                      static-blur = false;
                      style-dash-to-dock = false;
                      unblur-in-overview = false;
                  };

                  settings."org/gnome/shell/extensions/dash-to-dock" = {
                      apply-custom-theme = false;
                      background-color = "rgb(38,38,38)";
                      background-opacity = 0.4;
                      custom-background-color = true;
                      custom-theme-shrink = false;

                      dash-max-icon-size = 40;
                      disable-overview-on-startup = false;
                      dock-fixed = false;
                      dock-position = "BOTTOM";
                      extend-height = false;
                      hide-tooltip = false;
                      icon-size-fixed = false;
                      isolate-monitors = false;
                      isolate-workspaces = false;
                      multi-monitor = true;
                      preview-size-scale = 0;
                      scroll-to-focused-application = true;
                      show-apps-at-top = false;
                      show-favorites = true;
                      show-mounts = false;
                      show-mounts-network = true;
                      show-mounts-only-mounted = true;
                      show-running = true;
                      show-show-apps-button = false;
                      show-trash = false;
                      show-windows-preview = true;
                      transparency-mode = "FIXED";
                  };


                  settings."org/gnome/shell/extensions/sp-tray" = {
                      display-format = "{artist} » {track}";
                      display-mode = 1;
                      hidden-when-paused = false;
                      logo-position = 0;
                      marquee-length = 47;
                      marquee-tail = " ~ ";
                      paused = "⏸️ | ";
                      podcat-format = "»{track}«";
                      position = 1;
                      title-max-length = 35;
                  };
              };
    };
}