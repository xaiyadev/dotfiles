{
  lib,
  config,
  self,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;

  inherit (self.lib.modules) mkServiceOpt;
  cfg = config.sylveon.services.kitchenowl;
in
{
  options.sylveon.services.kitchenowl =
    mkServiceOpt "Kitchenowl" { port = 8050; domain = "kitchen.xaiya.dev"; };

  config = mkIf cfg.enable {
    # Create secrets
    age.secrets.kitchenowl-env.rekeyFile = "${inputs.self}/secrets/kitchenowl.env.age";

    # Enable the kitchenowl container
    virtualisation.oci-containers.containers.kitchenowl = {
      image = "tombursch/kitchenowl:latest";
      ports = [ "${builtins.toString cfg.port}:${builtins.toString cfg.port}" ];

      environmentFiles = [ config.age.secrets.kitchenowl-env.path ];
      volumes = [ "/mnt/raid/services/kitchenowl/data:/data" ];
    };

    # Enable proxy
    services.nginx.virtualHosts.${cfg.domain} = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://${cfg.host}:${builtins.toString cfg.port}";
        proxyWebsockets = true;
      };

      extraConfig = "proxy_ssl_server_name on;";
    };

  };
}
