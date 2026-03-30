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

  cfg = config.sylveon.services.piper;
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
          package = pkgs.nextcloud31;
          hostName = "127.0.0.1";

          database.createLocally = true;

          config = {
            adminpassFile = config.age.secrets."nextcloud-adminpass".path;

            dbhost = "postgresql://nextcloud?host=/run/postgresql";
          };
        };
      };
    })

    (mkIf config.sylveon.nginx.enable {
      services.nginx.virtualHosts.${cfg.domain} = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://localhost:${builtins.toString cfg.port}";
        };

        extraConfig = "proxy_ssl_server_name on;";

      };
    })
  ]);
}
