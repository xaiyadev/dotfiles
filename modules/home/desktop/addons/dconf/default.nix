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
  osConfig,
  specialArgs,
  ...
}:
with lib;
with lib.${namespace};
let
    cfg = config.${namespace}.desktop.addons.dconf;
in
{
  options.${namespace}.desktop.addons.dconf = with types; {
      enable = mkBoolOpt false "Load dconfiguration for your systems";

      gnome = {
        extensions = {
          packages = mkOpt (listOf package) [] "A list of Extensions that should be installed";
          configure = mkOpt bool true "Should these extensions be configured?";
        };

        wallpaper = mkOpt str "" "The wallpapaer as a string";
        favorite-apps = mkOpt (listOf str) [] "A list of apps that should be pinned at the bottom of the screen";
      };
  };

  config = mkIf cfg.enable {
    home.packages = cfg.gnome.extensions.packages;

    dconf = mkMerge [
      # Default Configuration that every Desktop Environment needs
      {
        enable = true;
        settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
      }

      (mkIf osConfig.${namespace}.desktop.gnome.enable # Configuration only needed by gnome
      {
        settings."org/gnome/shell" = {
          favorite-apps = cfg.gnome.favorite-apps;
          enabled-extensions = forEach cfg.gnome.extensions.packages (x: x.extensionUuid);
          disabled-extensions = []; # Make sure none of our extensions are disabled on system rebuild
        };

        settings."org/gnome/desktop/peripherals/mouse" = {
          accel-profile = "flat";
          speed = -0.7;
        };

        settings."org/gnome/desktop/wm/preferences" = {
            audible-bell = false;
            button-layout = ":minimize,maximize,close";
        };

        settings."org/gnome/desktop/interface" = {
          clock-format = "24h";
          show-battery-percentage = true;
        };

        settings."org/gnome/desktop/background" = {
          picture-uri = cfg.gnome.wallpaper;
          picture-uri-dark = cfg.gnome.wallpaper;
        };
      })

      (mkIf cfg.gnome.extensions.configure
      {
        settings."org/gnome/shell/extensions/user-theme".name = config.${namespace}.desktop.addons.gtk.theme.name;


        settings."org/gnome/shell/extensions/dash-to-dock" = {
          apply-custom-theme = true;
          dash-max-icon-size = 40;

          multi-monitor = true;
          show-running = false;
          show-trash = false;
        };

      })
    ];
  };
}
