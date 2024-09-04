
{ config, lib, pkgs, modulesPath, ... }:
with lib;
let
    cfg = config.services.soft-serve-services;
    sshdPort = 8888;
    softServePort = 22;
in
{
    options.services.soft-serve-services = {
        enable = mkEnableOption "custom soft-serve service";

        asDockerContainer = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = "should this service run as a docker container or not";
        };
    };

    config = mkIf cfg.enable {
      services.soft-serve = {
          enable = !cfg.asDockerContainer;

          settings = {
            name = "Semiko Git Server";
            log_format = "json";

            ssh = {
                listen_addr = ":23231";
                public_url = "ssh://soft-serve.semiko.dev";
                max_timeout = 30;
                idle_timeout = 120;
            };

            http.listen_addr = "2508";
          };
      };

      virtualisation.oci-containers.containers.soft-serve = mkIf cfg.asDockerContainer {
            image = "charmcli/soft-serve";
            autoStart = true;
            hostname = "soft-serve";
            volumes =
                [
                    "/mnt/raid/services/soft-serve/:/soft-serve:rw"
                ];

            ports =
                [
                    "23231:23231"
                    "23232:23232"
                    "23233:23233"
                    "9418:9418"
                ];

          environmentFiles = [
              config.age.secrets.soft-serve.path
          ];
    };
  };
}