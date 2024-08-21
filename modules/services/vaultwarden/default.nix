{ config, lib, pkgs, builtins, ... }:
with lib;
let
    cfg = config.services.vaultwarden;
in
{
    options.services.vaultwarden = {
        enable = mkEnableOption "custom vaultwarden service";
    };

    config = mkIf cfg.enable {

        # Vaultwarden creates System User, no need for manual creation!
        services.vaultwarden = {
            enable = true;
            dbBackend = "postgresql";

            config = {
                DOMAIN = "https://vault.semiko.dev";
                SIGNUPS_ALLOWED = false;

                # DATA_FOLDER = "/mnt/raid/services/vaultwarden/data/";
                # WEB_VAULT_FOLDER = "/mnt/raid/services/vaultwarden/web-vault/";

                DATABASE_URL = "postgresql://postgresql:${builtins.readFile config.age.secrets.secret1.path}/vaultwarden" ;

                ROCKET_ADRESS = "127.0.0.1";
                ROCKET_PORT = "127.0.0.1";
                ROCKET_LOG = "critical";

                # TODO: add Mail Server
            };

            services.bitwarden-directory-connector-cli.domain = "https://vault.semiko.dev";
        };

        services.nginx.virtualHosts."vault.semiko.dev" = {
            addSSL = true;
            enableACME = true;
            locations."/" = {
                proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
           };
        };

    };
}