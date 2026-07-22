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
        port = 2283;

        mediaLocation = "/mnt/storage/services/immich";

        settings.server.externalDomain = "https://photos.xaiya.dev";
      };

      nginx.virtualHosts."photos.xaiya.dev" = {
        useACMEHost = "xaiya.dev";
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://${config.services.immich.host}:${builtins.toString config.services.immich.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;

          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
          };

        extraConfig = "proxy_ssl_server_name on;";
      };
    };
  };
}
