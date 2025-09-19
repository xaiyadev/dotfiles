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

  inherit (self.lib.modules) mkPackageOpt;

  cfg = config.sylveon.programs.lutris;
in
{

  options.sylveon.programs.lutris = mkPackageOpt pkgs.lutris "Game Launcher";

  config = mkIf cfg.enable {
    programs.lutris = {
      enable = true;

      # packages
      steamPackage = osConfig.programs.steam.package;

      winePackages = [
        inputs'.nix-gaming.packages.wine-ge
      ];

      protonPackages = [
        pkgs.proton-ge-bin
      ];

      # Game runners
      runners = { };
    };
  };
}
