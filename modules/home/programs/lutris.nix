{
  config,
  lib,
  self,
  pkgs,
  inputs',
  osConfig,
  ...
}:
let

  inherit (lib)
    mkIf
    ;

  inherit (lib.types) bool;

  inherit (self.lib.modules) mkOpt;

  cfg = config.sylveon.programs.lutris;
in
{

  options.sylveon.programs.lutris = {
    enable = mkOpt bool false "Enable Game launcher";
  };

  config = mkIf cfg.enable {
    programs.lutris = {
      enable = true;

      # packages
      steamPackage = osConfig.programs.steam.package;

      # Wine packages build to long, find a solution TODO
      # Game runners TODO
      runners = { };
    };
  };
}
