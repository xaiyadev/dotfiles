{ lib, config, self, pkgs, ... }:
let
    inherit (lib) mkIf mkForce;

    inherit (self.lib.modules) mkPackageOpt;
    cfg = config.sylveon.services.plex;
in
{
    options.sylveon.services.plex =
      mkPackageOpt pkgs.plex "Plex (for my dad blegh)";

    config = mkIf cfg.enable {
      services.plex = {
        enable = true;
        openFirewall = true;

        dataDir = "/mnt/raid/Publish/Plex2";
      };
    };
}
