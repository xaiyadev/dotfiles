{
  config,
  inputs,
  inputs',
  osConfig,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    getExe
    mkForce
    ;

  sway = osConfig.sylveon.system.graphical.sway;
in
{

  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  config = mkIf sway.enable {
    services.vicinae = {
      enable = true;
      systemd.enable = false; # Is started through sway

      settings = {
        closeOnFocusLoss = true;
        font.size = 10;
        faviconService = "google";

        # theme configured by catppuccin
      
        window = {
          csd = true;
          opacity = 1;
          rounding = 10;
        };
      };
    };

    wayland.windowManager.sway.config.menu = 
      "${getExe config.services.vicinae.package} toggle";
  };
}
 
