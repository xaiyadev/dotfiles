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

    users.groups.firefly = {};
    users.users.firefly = {
        isSystemUser = true;
        initialPassword = "firefly";
        description = "Firefly";
        extraGroups = [ "networkmanager" ];
        group = "firefly"; # Firefly requirs you to add this group this way
    };


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

      /* --- Docker container --- */
      systemd.services.firefly-compose = {
          enable = cfg.asDockerContainer;
          wantedBy = ["multi-user.target"];
          after = ["docker.service" "docker.socket"];
          path = [ pkgs.docker ];

          script = ''docker compose -f ${./docker-compose.yml} --env-file ${config.age.secrets.firefly.path} up'';
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