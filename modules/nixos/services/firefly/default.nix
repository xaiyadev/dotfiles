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
        enable = mkEnableOption "Create a Cash managment Service!";

    };

    config = mkIf cfg.enable {
      # Load keys
      age.secrets.firefly.file = ../../../../secrets/firefly.env.age;

      virtualisation.oci-containers = {
        containers = {
          firefly-app = {
            image = "fireflyiii/core";
            autoStart = true;
            hostname = "app";
            dependsOn = [ "firefly-db" ];
            extraOptions = [ "--network=firefly" ];

            volumes =
            [
                "/mnt/raid/services/firefly/upload:/var/www/html/storage/upload:rw"
            ];

            ports =
            [
                "8023:8080" # WEB-UI
            ];

            environmentFiles = [
                config.age.secrets.firefly.path
            ];
          };

          firefly-db = {
            image = "mariadb";
            autoStart = true;
            hostname = "db";
            extraOptions = [ "--network=firefly" ];

            volumes =
              [
                  "/mnt/raid/services/firefly/database:/var/lib/mysql:rw"
              ];

            environmentFiles = [
                config.age.secrets.firefly.path
            ];

          };
        };
      };

      networking.firewall.allowedTCPPorts = [ 8023 ];
      services.nginx.virtualHosts."cash.semiko.dev" = {
          forceSSL = true;
          useACMEHost = "semiko.dev";
          locations."/".proxyPass = "http://[::1]:8023";
          extraConfig = "proxy_ssl_server_name on;";
      };
    };
}
