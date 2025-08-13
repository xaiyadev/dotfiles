{ config, lib, self, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (self.lib.modules) mkPackageOpt;

  cfg = config.sylveon.services.vaultwarden;
in
{

  options.sylveon.services.vaultwarden =
    mkPackageOpt pkgs.vaultwarden "Password manager";

  config = mkIf cfg.enable {
    age.secrets.vaultwarden-env.rekeyFile = "${self}/secrets/vaultwarden-env.age";

    services.postgresql = {
      ensureDatabases = [ "vaultwarden" ];

      ensureUsers = [{
        name = "vaultwarden";
        ensureDBOwnership = true;
      }];
    };

    services.vaultwarden = {
      enable = true;
      inherit (cfg) package;
      
      dbBackend = "postgresql";

      config = {
        DOMAIN = "https://vault.xaiya.dev";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "::1";
        ROCKET_PORT = 8222;
        DATABASE_URL=postgresql://vaultwarden?host=/run/postgresql;
      };

      environmentFile = config.age.secrets.vaultwarden-env.path;
    };

    services.nginx.virtualHosts."vault.xaiya.dev" = {
      enableACME = true;
      forceSSL = true;

      locations."/".proxyPass = "http://[::1]:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      extraConfig = "proxy_ssl_server_name on;";
    };
  };

}
