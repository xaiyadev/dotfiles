{
  lib,
  config,
  self,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.sylveon.services.kitchenowl;
in
{
  options.sylveon.services.kitchenowl.enable = mkEnableOption "Kitchenowl";

  config = mkIf cfg.enable {
    # Create secrets
    age.secrets.kitchenowl-env.rekeyFile = "${inputs.self}/secrets/kitchenowl.env.age";

    # Enable the kitchenowl container
    virtualisation.oci-containers.containers.kitchenowl = {
      image = "tombursch/kitchenowl:latest";
      ports = [ "8050:8080" ];

      environmentFiles = [ config.age.secrets.kitchenowl-env.path ];
      volumes = [ "/mnt/storage/services/kitchenowl:/data" ];
    };

    # Enable proxy
    services.nginx.virtualHosts."kitchen.xaiya.dev" = {
      useACMEHost = "xaiya.dev";
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:8050";
      };

      extraConfig = "proxy_ssl_server_name on;";
    };
  };
}
