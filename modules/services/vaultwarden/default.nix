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
            dbBackend = "postgresql";

            config = {
                DOMAIN = "https://vault.semiko.dev";
                SIGNUPS_ALLOWED = false;

                # DATA_FOLDER = "/mnt/raid/services/vaultwarden/data/";
                # WEB_VAULT_FOLDER = "/mnt/raid/services/vaultwarden/web-vault/";

                DATABASE_URL = "postgresql://postgresql:${builtins.readFile config.age.secrets.postgresql.path}/vaultwarden" ;

                ROCKET_ADRESS = "127.0.0.1";
                ROCKET_PORT = "9000";
                ROCKET_LOG = "critical";

                # TODO: add Mail Server
            };

        };
        services.bitwarden-directory-connector-cli.domain = "https://vault.semiko.dev";

        services.nginx.virtualHosts."vault.semiko.dev" = {
            addSSL = true;
            enableACME = true;
            locations."/".proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
           extraConfig =
             # required when the target is also TLS server with multiple hosts
             "proxy_ssl_server_name on;" +
             # required when the server wants to use HTTP Authentication
             "proxy_pass_header Authorization;"
             ;
        };

    };
}