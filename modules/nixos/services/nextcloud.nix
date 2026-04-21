{
  config,
  lib,
  self,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  inherit (self.lib.modules) mkServiceOpt;

  cfg = config.sylveon.services.nextcloud;
in
{

  options.sylveon.services.nextcloud =
    mkServiceOpt "nextcloud" { port = 3015; domain = "cloud.xaiya.dev"; };

  config = (mkMerge [
    (mkIf cfg.enable {
      # Create secrets
      age.secrets."nextcloud-adminpass".rekeyFile = "${self}/secrets/nextcloud-adminpass.age";

      services = {
        nextcloud = {
          enable = true;
          package = pkgs.nextcloud33;
          hostName = "100.112.47.9";

          config = {
            adminpassFile = config.age.secrets."nextcloud-adminpass".path;

            dbtype = "sqlite"; # TODO
          };
        };
      };
    })
  ]);
}
