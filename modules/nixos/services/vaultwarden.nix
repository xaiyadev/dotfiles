{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib.modules) mkServiceOpt;

  cfg = config.sylveon.services.vaultwarden;
in
{

  options.sylveon.services.vaultwarden =
    mkServiceOpt "Vaultwarden" { port = 8222; domain = "vault.xaiya.dev"; };

  config = mkIf cfg.enable {
    # Create secrets
    age.secrets.vaultwarden-env.rekeyFile = "${self}/secrets/vaultwarden-env.age";

    services = {
      vaultwarden = {
        enable = true;
        
        dbBackend = "postgresql";
        
        config = {
          DOMAIN = "https://${cfg.domain}";
          SIGNUPS_ALLOWED = false;
        
          ROCKET_ADDRESS = "::1"; 
          ROCKET_PORT = cfg.port;
          DATABASE_URL = "postgresql://vaultwarden?host=/run/postgresql";
        };
        
        environmentFile = config.age.secrets.vaultwarden-env.path;
      };

      postgresql = {
        ensureDatabases = [ "vaultwarden" ];
        ensureUsers = [{ name = "vaultwarden"; ensureDBOwnership = true; }];
      };

      # Create proxy entry
      nginx.virtualHosts.${cfg.domain} = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://${cfg.host}:${builtins.toString cfg.port}";
        };

        extraConfig = "proxy_ssl_server_name on;";

      };
    };
  };
}
