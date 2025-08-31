{ lib, config, self, inputs, ... }:
let
    inherit (lib) mkIf;
    inherit (lib.types) bool;

    inherit (self.lib.modules) mkOpt;
    cfg = config.sylveon.services.plex;
in
{
    options.sylveon.services.kitchenowl.enable = mkOpt bool false "cooking book (still maintend on docker)"; # TODO

    config = mkIf cfg.enable {
      age.secrets.kitchenowl-env.rekeyFile = "${inputs.self}/secrets/kitchenowl.env.age";

      virtualisation.oci-containers.containers.kitchenowl = {
        image = "tombursch/kitchenowl:latest";
        ports = [ "8050:8080" ];

        environmentFiles = [ config.age.secrets.kitchenowl-env.path ];
        volumes = [ "/mnt/raid/services/kitchenowl/data:/data" ];
      };

      services.nginx.virtualHosts."kitchen.xaiya.dev" = {
        enableACME = true;
        forceSSL = true;

        locations."/".proxyPass = "http://127.0.0.1:8050";
        extraConfig = "proxy_ssl_server_name on;";
      };
    };
}
