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
        firefly.rekeyFile = "${inputs.self}/secrets/firefly.env.age";
        firefly-db.rekeyFile = "${inputs.self}/secrets/firefly.db.env.age";
      };


      containers.firefly = {
        autoStart = true;
        privateNetwork = true;
        hostAdress = "192.168.100.1";
        localAdress = "192.168.1.126";

        config = {}: {
            services.firefly-iii = {
                enable = true;
                dataDir = "/mnt/raid/services/firefly/data/";
                virtualHost = "https://xaiya.dev/";

                settings = {
                    APP_ENV = "production";
                    APP_KEY_FILE = config.age.secrets.firefly-api.path;
                    TRUSTED_PROXIES="**";

                    SITE_OWNER="d.schumin@proton.me";
                    TZ="Europe/Berlin";

                    /* Database configuraiton */
                    DB_CONNECTION = "pgsql";

                    # Use new layout
                    FIREFLY_III_LAYOUT="v2";
                };

            };
        };

      };

      virtualisation.oci-containers = {
        containers = {
          firefly-app = {
            image = "fireflyiii/core";
            autoStart = true;
            dependsOn = [ "firefly-db" ];
            extraOptions = [ "--network=firefly" ];

            volumes = [ "/mnt/raid/services/firefly/upload:/var/www/html/storage/upload:rw" ];

            ports = [ "8023:8080" ]; # WEB-UI

            environmentFiles = [
                config.age.secrets.firefly.path
            ];
          };

          firefly-db = {
            image = "mysql";
            autoStart = true;
            extraOptions = [ "--network=firefly" ];

            volumes = [ "/mnt/raid/services/firefly/database:/var/lib/mysql:rw" ];

            environmentFiles = [
                config.age.secrets.firefly-db.path
            ];

          };
        };
      };

      services.nginx.virtualHosts."cash.xaiya.dev" = {
          forceSSL = true;
          useACMEHost = "xaiya.dev";
          root = "${config.services.firefly-iii.package}";
      };
    };
}