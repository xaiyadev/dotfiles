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
in {

  # This configuration will only be enabled when the nixOS modules is enabled
  # This helps with visibility and keeps them in one
  config = mkIf osConfig.${namespace}.desktop.gnome.enable {

    home.packages = [
      pkgs.smile # Emoji Picker
    ];

    /* Install all nesecerry addons */
    ${namespace}.desktop.addons = {
      keyring = enabled;

      wofi = enabled;

      gtk = enabled;
      dconf = {
        enable = true;

        gnome = {
          wallpaper = builtins.toString ./wallpapers/dawn.jpg;

          extensions.packages = [
            pkgs.gnomeExtensions.dash-to-dock
            pkgs.gnomeExtensions.user-themes
            pkgs.gnomeExtensions.blur-my-shell
            pkgs.gnomeExtensions.appindicator
          ];

          favorite-apps = [
            "webstorm.desktop"
            "chromium-browser.desktop"
            "vesktop.desktop"
            "spotify.desktop"
          ];
        };
      };
    };
  };
}
    
