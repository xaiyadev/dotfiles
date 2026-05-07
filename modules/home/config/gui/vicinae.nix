{
  config,
  inputs,
  osConfig,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;

  sway = osConfig.sylveon.graphical.sway;
in
{
  config = mkIf sway.enable {
    programs.vicinae = {
      enable = true;
      systemd.enable = false; # Is started through sway

      settings = {
        window.opacity = 1;
      };

      # TODO configure
    };
  };
}
