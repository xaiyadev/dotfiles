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
      autoStart = false; # Start the server with sway TODO: create stand-alone module
      package = inputs'.vicinae.packages.default;

      settings = {
        closeOnFocusLoss = true;
        font.size = 10;
        faviconService = "google";

        theme = {
          iconTheme = "BreezeX-RoséPine";
          name = "rosepine-base.json";
        };

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
 
