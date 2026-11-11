{ lib, osConfig, pkgs, ... }:

let
  inherit (lib)
    mkIf
    ;

  inherit (osConfig.sylveon.graphical) sway;
in
{
  config = mkIf sway.enable {
    programs.quickshell = {
      enable = true;

      package = pkgs.symlinkJoin {
        name = "wrapped-quickshell";
        paths = [
          pkgs.quickshell
          pkgs.adwaita-icon-theme
          pkgs.brightnessctl
          pkgs.framework-tool
          pkgs.networkmanagerapplet  # nm-connection-editor
        ];

        meta.mainProgram = pkgs.quickshell.meta.mainProgram;
      };
    };

    # get the quickshell configuration into the config directory
    xdg.configFile."quickshell".source = ./config;
  };
}
