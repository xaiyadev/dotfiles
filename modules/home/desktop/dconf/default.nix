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
    cfg = config.${namespace}.desktop.dconf;
in
{
    options.${namespace}.desktop.dconf = {
        enable = mkEnableOption "setup gnome and dconf settings!";

        favorite-apps = mkOption {
            type = types.listOf types.str;
            default =  [
                "chromium.desktop"
                "vesktop.desktop"
                "spotify.desktop"
            ];

            description = "programs saved in the tray-bar";
        };

        wallpaper = mkOption {
            type = types.str;
            default = "rainbow-cat.png";
            description = "The file name in './wallpapers/'";
        };
    };

    config = mkIf cfg.enable {
         home.file.".config/wallpapers/rainbow-cat.png".source = ./wallpapers/${cfg.wallpaper};

          gtk = {
            enable = true;
                theme = {
                      name = "Colloid-Dark-Catppuccin";
                      package = pkgs.colloid-gtk-theme.override {
                        themeVariants = ["default"];
                        colorVariants = ["dark"];
                        sizeVariants = ["standard"];
                        tweaks = ["catppuccin"];
                      };
                    };

            iconTheme = {
                package = pkgs.colloid-icon-theme;
                name = "Colloid";
            };
          };

          dconf = {
              enable = true;
              settings."org/gnome/desktop/background".picture-ui = ".config/wallpapers/${cfg.wallpaper}";

              settings."org/gnome/shell/extensions/user-theme".name = "Colloid-Dark-Catppuccin";

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
                       "user-theme@gnome-shell-extensions.gcampax.github.com"
                       "stopwatch@aliaskeiz.github.com"
                  ];
              };

              /* --- Extension Settings --- */

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