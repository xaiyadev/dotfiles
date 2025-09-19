{
  lib,
  config,
  self,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (self.lib.modules) mkPackageOpt;
  cfg = config.sylveon.services.firefly;
in
{
  options.sylveon.services.firefly = mkPackageOpt pkgs.firefly-iii "Postgres databases and stuff";

  config = mkIf cfg.enable {
    age.secrets = {
      firefly-app-key = {
        rekeyFile = "${inputs.self}/secrets/firefly.app-key.age";

        # Set read permissions
        owner = "root";
        group = config.services.firefly-iii.group;
        mode = "0440";
      };
    };

    services = {
      postgresql = {
        ensureDatabases = [ config.services.firefly-iii.user ];
        ensureUsers = [
          {
            name = config.services.firefly-iii.user;
            ensureDBOwnership = true;
          }
        ];
      };

      firefly-iii = {
        enable = true;
        inherit (cfg) package;

        group = "nginx";
        virtualHost = "cash.xaiya.dev";

        settings = {
          APP_ENV = "local";
          APP_KEY_FILE = config.age.secrets.firefly-app-key.path;
          TRUSTED_PROXIES = "**";

          SITE_OWNER = "d.schumin@proton.me";
          TZ = "Europe/Berlin";

          /*
            Database configuraiton
            Postgres needs to be installed!
          */
          DB_CONNECTION = "pgsql";

          DB_USERNAME = config.services.firefly-iii.user;
          DB_SOCKET = "/run/postgresql";
          DB_DATABASE = config.services.firefly-iii.user;

          # New layout still buggy :(
          FIREFLY_III_LAYOUT = "v1";
        };
      };

      nginx.virtualHosts.${config.services.firefly-iii.virtualHost} = {
        forceSSL = true;
        useACMEHost = "xaiya.dev";
        root = "${config.services.firefly-iii.package}/public";

        locations = {
          # Find and load the index.php
          "/" = {
            tryFiles = "$uri $uri/ /index.php?$query_string";
            index = "index.php";
            extraConfig = ''
              sendfile off;
            '';
          };

          # PHP files load correctly
          "~ \.php$" = {
            extraConfig = ''
              include ${config.services.nginx.package}/conf/fastcgi_params ;
              fastcgi_param SCRIPT_FILENAME $request_filename;
              fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
              fastcgi_pass unix:${config.services.phpfpm.pools.firefly-iii.socket};
            '';
          };

        };
      };
    };
  };
}
