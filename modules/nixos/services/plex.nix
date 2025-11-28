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
  cfg = config.sylveon.services.plex;
in
{
  options.sylveon.services.plex = {
    enable = mkOpt bool false "Enable a plex media server";
  };

  config = mkIf cfg.enable {
    services.plex = {
      enable = true;
      openFirewall = true;

      dataDir = "/mnt/raid/Publish/Plex2";
    };
  };
}
