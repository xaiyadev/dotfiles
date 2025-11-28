{
  lib,
  config,
  self,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.types) bool;

  inherit (self.lib.modules) mkOpt;
  cfg = config.sylveon.services.docker;
in
{
  options.sylveon.services.docker = { 
    enable = mkOpt bool false "Docher Service"; 
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      # storageDriver = "btrfs"; TODO: 0 // change if redoing apricot

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
