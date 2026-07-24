{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.sylveon.services.webdav;
in
{

  options.sylveon.services.webdav.enable = mkEnableOption "webdav server";

  config = mkIf cfg.enable {
    services = {
      webdav = {
        enable = true;

        settings = {
          address = "0.0.0.0";
          port = 6065;

          behindProxy = true;
          directory = "/mnt/storage/webdav/";
          permissions = "RCUD"; # users having access to this webdav should have complete access to it
          users = [
            {
              username = "xaiya";
              password = "{bcrypt}$2a$10$HfHSZ/HtbRBlgpTRT4XuK.NtLxz6hqrvr3Wj/NMBe0AgvkVIwEQRu";
            } 
          ];
        };
      };

      nginx.virtualHosts."files.xaiya.dev" = {
        useACMEHost = "xaiya.dev";
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${builtins.toString config.services.webdav.settings.port}";

          # taken from: https://github.com/hacdias/webdav#nginx-configuration-example
          extraConfig = ''
            proxy_set_header REMOTE-HOST $remote_addr;
            proxy_redirect off;

            set $dest $http_destination;
            if ($http_destination ~ "^https://files.xaiya.dev(?<path>(.+))") {
              set $dest $path;
            }

            proxy_set_header Destination $dest;
          '';
          };
      };
    };
  };
}
