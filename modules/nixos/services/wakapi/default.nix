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
    cfg = config.${namespace}.services.wakapi;
in
{
    options.${namespace}.services.wakapi = with types; {
        enable = mkBoolOpt false "Statistics for developing";
    };

    config = mkIf cfg.enable {

      services.postgresql = {
        ensureDatabases = [ config.services.wakapi.settings.db.user ];

        ensureUsers = [{
            name = config.services.wakapi.settings.db.user;
            ensureDBOwnership = true;
        }];
      };

      services.wakapi = {
        enable = false; # TODO: make PR, typo posgres -> postgres

        database = {
          dialect = "postgres";
          createLocally = false;
        };
        
        settings = {
          db = {
            socket = "/run/postgresql";
            dialect = "postgres";
            user = "wakapi";
            name = "wakapi";
          };
        };
      };

      virtualisation.oci-containers.containers.wakapi = {
        image = "ghr.io/meuty/wakapi:latest";
          autoStart = true;
          ports = [ "3000:3000" ];
      };

      services.nginx.virtualHosts."wakapi.xaiya.dev" = {
        forceSSL = true;
        useACMEHost = "xaiya.dev";
        locations."/".proxyPass = "http://[::1]:3000";
        extraConfig = "proxy_ssl_server_name on;";
      };
    };
}

