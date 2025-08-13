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

    services.vaultwarden = {
      enable = true;
      inherit (cfg) package;
      
      dbBackend = "postgresql";

      config = {
        DOMAIN = "https://vault.xaiya.dev";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "::1";
        ROCKET_PORT = 8222;
      };

      environmentFile = config.age.secrets.vaultwarden-env.path;
    };
  };

}
