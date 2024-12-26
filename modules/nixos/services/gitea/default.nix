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
with lib.${namespace};
let
    cfg = config.${namespace}.services.gitea;
in
{
    options.${namespace}.services.gitea = with types; {
        enable = mkBoolOpt false "Git instanced for syncing services";
    };

    config = mkIf cfg.enable {

      # Create Database
      services.postgresql = {
        ensureDatabases = [ config.services.gitea.user ];
        ensureUsers = [{
            name = config.services.gitea.user;
            ensureDBOwnership = true;
        }];
      };

      services.gitea = {
        enable = true;
        appName = "gitea: Xaiya's Sync Server";

        database = {
          createDatabase = false;

          # Use Socket with peer connection to login
          type = "postgres";
          socket = "/run/postgresql";

          name = config.services.gitea.user;
          user = config.services.gitea.user;

        };

        settings = {
          "server" = {
            DOMAIN = "git.xaiya.dev";
            ROOT_URL = "https://git.xaiya.dev";
            HTTP_PORT = 4931;

            PROTOCOL = "http";
          };

          "service" = {
            DISABLE_REGISTRATION = true; # Needs to be disabled when creating a new server
          };

          "cron.sync_external_users" = {
            RUN_AT_START = true;
            SCHEDULE = "@every 24h";
            UPDATE_EXISTING = true;
          };
        };
      };

      services.nginx.virtualHosts.${config.services.gitea.settings."server".DOMAIN} = {
        forceSSL = true;
        useACMEHost = "xaiya.dev";

        locations."/".proxyPass = "http://[::1]:4931";
      };

    };
}