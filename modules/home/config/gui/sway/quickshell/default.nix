{ lib, osConfig, ... }:

let
  inherit (lib)
    mkIf
    ;

  inherit (osConfig.sylveon.graphical) sway;
in
{
  config = mkIf sway.enable {
    programs.quickshell.enable = true;
    xdg.configFile."quickshell".source = ./config;
  };
}
