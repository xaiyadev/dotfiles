{
  lib,
  config,
  self,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (self.lib.modules) mkPackageOpt;
  cfg = config.sylveon.services.docker;
in
{
  options.sylveon.services.docker = mkPackageOpt pkgs.docker "Docker for managing";

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
