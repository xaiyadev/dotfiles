{
  config,
  self,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.types) bool;
  inherit (lib) mkIf;
  inherit (lib.modules) mkMerge;
  inherit (self.lib.modules) mkOpt;

  cfg = config.sylveon.hardware.controller;
  prof = config.sylveon.profiles;
in
{

  options.sylveon.hardware.controller = {
    xbox.enable =
      mkOpt bool prof.gaming.enable "Whether or not xbox controller should be enabled or not";
  };

  config = mkMerge [
    (mkIf cfg.xbox.enable {
      hardware.xpadneo.enable = true;
      boot.extraModulePackages = [ config.boot.kernelPackages.xpadneo ];
    })
  ];

}
