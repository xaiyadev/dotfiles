{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.firefly;
in
{
    options.services.firefly = {
        enable = mkEnableOption "custom firefly service";

        asDockerContainer = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = "should this service run as a docker container or not";
        };
    };

    config = mkIf cfg.enable {

    services.firefly-iii = {
        enable = !cfg.asDockerContainer;
        enableNginx = true;
        #dataDir = "/mnt/raid/services/firefly/";
        group = "firefly";
        user = "firefly";

        settings = {
            APP_ENV= "production";
            SITE_OWNER = "danil80sch@gmail.com";
            APP_KEY_FILE = config.age.secrets.firefly.path;
            DEFAULT_LANGUAGE="de_DE";
            TRUSTED_PROXIES="**";

            DB_CONNECTION="pgsql";
            DB_DATABASE="firefly";
            DB_HOST="/run/postgresql";
            DB_PORT = 5432;
        };
    };

      systemd.services = {
          firefly-network = {
                description = "Create the network bridge for firefly.";
                after = [ "network.target" ];
                wantedBy = [ "multi-user.target" ];
                serviceConfig.Type = "oneshot";
                script = ''
                      check=$(${pkgs.docker}/bin/docker network ls | grep "firefly" || true)
                  if [ -z "$check" ]; then
                    ${pkgs.docker}/bin/docker network create firefly
                  else
                    echo "Firefly network already exists in docker!"
                  fi
                '';
          };
      };

      virtualisation.oci-containers = mkIf cfg.asDockerContainer {
            containers = {
                firefly-app = {
                  image = "fireflyiii/core";
                  autoStart = true;
                  hostname = "app";
                  dependsOn = [ "firefly-db" ];
                  extraOptions = [ "--network=firefly" ];

                  volumes =
                  [
                      "/mnt/raid/services/firefly/upload:/var/www/html/storage/upload:rw"
                  ];

                  ports =
                  [
                      "8023:8080" # WEB-UI
                  ];

                  environmentFiles = [
                      config.age.secrets.firefly.path
                  ];
                };

                firefly-db = {
                  image = "mariadb";
                  autoStart = true;
                  hostname = "db";
                  extraOptions = [ "--network=firefly" ];

                  volumes =
                    [
                        "/mnt/raid/services/firefly/database:/var/lib/mysql:rw"
                    ];

                  environmentFiles = [
                      config.age.secrets.firefly.path
                  ];

                };
            };

        };

    networking.firewall.allowedTCPPorts = [ 8023 ];
    services.nginx.virtualHosts."cash.semiko.dev" = {
        forceSSL = true;
        useACMEHost = "semiko.dev";
        locations."/".proxyPass = "http://127.0.0.1:8023";
        extraConfig = "proxy_ssl_server_name on;";
    };
  };
}