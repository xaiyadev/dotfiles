# Extra Specific dconf settings
{ pkgs, ... }:
{
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "org.prismlauncher.PrismLauncher.desktop"
        "webstorm.desktop"
        "librewolf.desktop"
        "vesktop.desktop"
        "TIDAL Hi-Fi.desktop"
      ];
    };
  };
}
