{
  config,
  pkgs,
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
      package = pkgs.vicinae; # Outdated but more stable version built by hydra
      systemd.enable = false; # Is started through sway

      settings = {
        launcher_window.opacity = 1;
      };

      # TODO: add extensions
    };
  };
}

