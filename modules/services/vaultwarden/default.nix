{ config, lib, pkgs, ... }:
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
            # TODO: learn how to add passwords to env file

            config = {
                DOMAIN = "https://vault.semiko.dev";
                SIGNUPS_ALLOWED = false;

                ROCKET_ADRESS = "127.0.0.1";
                ROCKET_PORT = "127.0.0.1";

                ROCKET_LOG = "critical";

                # TODO: add Mail Server
            };

            services.bitwarden-directory-connector-cli.domain = "https://vault.semiko.dev";
        };
  };
}