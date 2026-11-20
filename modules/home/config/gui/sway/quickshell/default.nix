{ lib, osConfig, pkgs, ... }:

let
  inherit (lib)
    mkIf
    ;

  inherit (osConfig.sylveon.graphical) sway;
in
{
  config = mkIf sway.enable {
    programs.quickshell.enable = true;

    # packages needed by quickshell
    sylveon.packages = {
      inherit (pkgs) adwaita-icon-theme; # icon themes mostly used for apps
      inherit (pkgs) sound-theme-freedesktop; # sound pack
      inherit (pkgs) libnotify; # notifications
    };

    # get the quickshell configuration into the config directory
    xdg.configFile."quickshell".source = ./config;
  };
}
