{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.vaultwardenService;
in
{
    options.services.vaultwardenService = {
        enable = mkEnableOption "custom vaultwarden service";
    };

    config = mkIf cfg.enable {



        # Vaultwarden creates System User, no need for manual creation!
        services.vaultwarden = {
            enable = true;
            dbBackend = "sqlite";

            config = {
                DOMAIN = "https://vault.semiko.dev";
                SIGNUPS_ALLOWED = false;

                # TODO: look how to save data their
                #DATA_FOLDER = "/mnt/raid/services/vaultwarden/data/";
                #WEB_VAULT_FOLDER = "/mnt/raid/services/vaultwarden/web-vault/";

                #DATABASE_URL = "/run/postgresql";

                ROCKET_ADRESS = "::";
                ROCKET_PORT = 8000;

                # TODO: add Mail Server
            };

        };

        services.bitwarden-directory-connector-cli.domain = "https://vault.semiko.dev";

        services.nginx.virtualHosts."vault.semiko.dev" = {
            forceSSL = true;
            useACMEHost = "semiko.dev";
            locations."/".proxyPass = "http://[::1]:8000";
            extraConfig = "proxy_ssl_server_name on;";
        };

    };
}