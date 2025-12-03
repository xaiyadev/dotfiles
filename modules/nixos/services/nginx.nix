{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.types) bool;

  inherit (self.lib.modules) mkOpt;

  cfg = config.sylveon.services.nginx;
in
{

  options.sylveon.services.nginx = {
    enable = mkOpt bool false "Enable Nginx proxy";
  };

  config = mkIf cfg.enable {
    age.secrets.cloudflare-acme.rekeyFile = "${self}/secrets/cloudflare-acme.age";

    users.users.nginx.extraGroups = [ "acme" ];

    # Base website ports opened for nginx
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];


    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "d.schumin@proton.me";
      certs."xaiya.dev" = {
        domain = "*.xaiya.dev";

        dnsProvider = "cloudflare";
        webroot = null;

        group = "nginx";
        environmentFile = config.age.secrets.cloudflare-acme.path;
      };
    };
  };
}
