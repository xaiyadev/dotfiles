{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.sylveon.services.docker;
in
{
  options.sylveon.services.docker = {
    enable = mkEnableOption "Whether or not to enable Docker";
  };

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
