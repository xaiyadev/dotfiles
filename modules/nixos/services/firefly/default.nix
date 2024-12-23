{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  config,
  specialArgs,
  ...
}:
with lib;
let
    cfg = config.${namespace}.services.firefly;
in
{
    options.${namespace}.services.firefly = {
        enable = mkEnableOption "Whether or not to enable the firefly services for cash managment";
    };

    config = mkIf cfg.enable {
      age.secrets = {
        firefly-app-key = {
          rekeyFile = "${inputs.self}/secrets/firefly.app-key.age";

          # Set read permissions for firefly
          owner = "root";
          group = config.services.firefly-iii.group;
          mode = "0440";
        };
      };

      services.postgresql = {
        ensureDatabases = [ config.services.firefly-iii.user ];
        ensureUsers = [{
            name = config.services.firefly-iii.user;
            ensureDBOwnership = true;
        }];
      };


      services.firefly-iii = {
        enable = true;
        enableNginx = true;
        virtualHost = "cash.xaiya.dev";

        settings = {
            APP_ENV = "local";
            APP_KEY_FILE = config.age.secrets.firefly-app-key.path;
            TRUSTED_PROXIES="**";

            SITE_OWNER="d.schumin@proton.me";
            TZ="Europe/Berlin";

            /*
             * Database configuraiton
             * Postgres needs to be installed!
            */
            DB_CONNECTION = "pgsql";

            DB_USERNAME = config.services.firefly-iii.user;
            DB_SOCKET = "/run/postgresql";
            DB_DATABASE = config.services.firefly-iii.user;

            # New layout still buggy :(
            FIREFLY_III_LAYOUT="v2";
        };
      };

      # Manually create maintance script because of hard recreatinudo
      services.nginx.virtualHosts.${config.services.firefly-iii.virtualHost} = {
          forceSSL = true;
          useACMEHost = "xaiya.dev";
      };
    };
}