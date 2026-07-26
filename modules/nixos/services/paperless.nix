{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.sylveon.services.immich;
in
{

  options.sylveon.services.paperless.enable = mkEnableOption "Paperless Document Manager";

  config = mkIf cfg.enable {
    services = {
      paperless = {
        enable = true;
        
        domain = "documents.xaiya.dev";
        configureTika = true;

        dataDir = "/mnt/storage/services/paperless";

        settings = {
          PAPERLESS_AUTO_LOGIN_USERNAME = "admin"; # We are running this system in a vpn, this is a okay !
        };
      };

      nginx.virtualHosts."${config.services.paperless.domain}" = {
        useACMEHost = "xaiya.dev";
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://${config.services.paperless.address}:${builtins.toString config.services.paperless.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };

        extraConfig = "proxy_ssl_server_name on;";
      };
    };
  };
}
