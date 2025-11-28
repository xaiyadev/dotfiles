{
  config,
  lib,
  self,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.types) bool;
  inherit (self.lib.modules) mkOpt mkService;

  cfg = config.sylveon.services.vaultwarden;
in
{

  options.sylveon.services.vaultwarden = {
    enable = mkOpt bool false "Enable Password Manager vaultwarden";
  };

  config = (mkIf cfg.enable (mkService {
    secrets = [{ name = "vaultwarden-env"; }];
    databases = [ "vaultwarden" ];

    proxy = {
      domain = "vault.xaiya.dev";
      port = (toString config.services.vaultwarden.config.ROCKET_PORT);
    };
  } // {

    services.vaultwarden = {
      enable = true;
      inherit (cfg) package;

      dbBackend = "postgresql";

      config = {
        DOMAIN = "https://vault.xaiya.dev";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "::1";
        ROCKET_PORT = 8222;
        DATABASE_URL = "postgresql://vaultwarden?host=/run/postgresql";
      };

      environmentFile = config.age.secrets.vaultwarden-env.path;
    };

  }));
}
