{ lib, osConfig, config, pkgs, self, ... }:
let
  inherit (lib) forEach;
  inherit (lib.modules) mkIf;
  inherit (lib.types) listOf package;

  inherit (self.lib.modules) mkOpt;


  windowManagers = osConfig.sylveon.system.graphical.windowManagers;
  cfg = config.sylveon.gnome;
in
{

  options.sylveon.gnome.extensions =
    mkOpt (listOf package)
      [
        pkgs.gnomeExtensions.blur-my-shell
        pkgs.gnomeExtensions.dash-to-dock
        pkgs.gnomeExtensions.user-themes
        pkgs.gnomeExtensions.blur-my-shell
        pkgs.gnomeExtensions.appindicator
        pkgs.gnomeExtensions.window-is-ready-remover
        pkgs.gnomeExtensions.tailscale-qs
      ]
      "A list of users that should be installed";

  config = mkIf (builtins.elem "gnome" windowManagers) {
    home.packages = cfg.extensions;

    dconf = {

      settings."org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = forEach cfg.extensions (x: x.extensionUuid);
      };

      # TODO: add extensions configuration
    };
  };
}
