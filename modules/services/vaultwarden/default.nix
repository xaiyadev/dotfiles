{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.vaultwardenService;
in
{
    options.services.vaultwardenService = {
        enable = mkEnableOption "custom vaultwarden service";

        asDockerContainer = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = "should this service run as a docker container or not";
        };
    };

    config = mkIf cfg.enable {
            networking.firewall.allowedTCPPorts = [ 9445 ];

            /* --- on Server --- */
            # Vaultwarden creates System User, no need for manual creation!
            services.vaultwarden = {
                    enable = !cfg.asDockerContainer;
                    dbBackend = "sqlite";


                    config = {
                        DOMAIN = "https://vault.semiko.dev";
                        SIGNUPS_ALLOWED = false;

                        # TODO: look how to save data their
                        #DATA_FOLDER = "/mnt/raid/services/vaultwarden/data/";
                        #WEB_VAULT_FOLDER = "/mnt/raid/services/vaultwarden/web-vault/";

                        #DATABASE_URL = "/run/postgresql";

                        # TODO: add Mail Server

                        ROCKET_ENV="staging";
                        ROCKET_ADRESS="::";
                        ROCKET_PORT = 9445;
                    };

                };

            /* --- Docker container --- */
            systemd.services.vaultwarden-compose = {
                enable = cfg.asDockerContainer;
                wantedBy = ["multi-user.target"];
                after = ["docker.service" "docker.socket"];
                path = [ pkgs.docker ];

                script = ''docker compose -f ${./docker-compose.yml} up '';
            };




        services.nginx.virtualHosts."vault.semiko.dev" = {
            forceSSL = true;
            useACMEHost = "semiko.dev";
            locations."/".proxyPass = "http://[::1]:9445";
            extraConfig = "proxy_ssl_server_name on;";
        };

    };
}