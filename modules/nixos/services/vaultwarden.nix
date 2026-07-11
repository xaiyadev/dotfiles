{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (self.lib.modules) mkServiceOpt;

  cfg = config.sylveon.services.vaultwarden;
in
{

  options.sylveon.services.vaultwarden.enable = mkEnableOption "Vaultwarden";

  config = mkIf cfg.enable {
    # Create secrets
    age.secrets.vaultwarden-env.rekeyFile = "${self}/secrets/vaultwarden-env.age";

    services = {
      vaultwarden = {
        enable = true;

        dbBackend = "postgresql";

        config = {
          DOMAIN = "https://vault.xaiya.dev";
          SIGNUPS_ALLOWED = true;

          ROCKET_ADDRESS = "::1";
          ROCKET_PORT = 8222;
          DATABASE_URL = "postgresql://vaultwarden?host=/run/postgresql";
        };

        environmentFile = config.age.secrets.vaultwarden-env.path;
      };

      postgresql = {
        ensureDatabases = [ "vaultwarden" ];
        ensureUsers = [{ name = "vaultwarden"; ensureDBOwnership = true; }];
      };

      # Create proxy entry
      nginx.virtualHosts."vault.xaiya.dev" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://[::1]:8222";
        };

        extraConfig = "proxy_ssl_server_name on;";

      };
    };
  };
}
