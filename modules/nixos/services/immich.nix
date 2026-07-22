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

  options.sylveon.services.immich.enable = mkEnableOption "Enable immich service";

  config = mkIf cfg.enable {
    services = {
      immich = {
        enable = true;
        host = "127.0.0.1";

        settings.server.externalDomain = "https://photos.xaiya.dev";
      };

      nginx.virtualHosts."photos.xaiya.dev" = {
        useACMEHost = "xaiya.dev";
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:2283";
          proxyWebsockets = true;
        };

        extraConfig = "proxy_ssl_server_name on;";
      };
    };
  };
}
