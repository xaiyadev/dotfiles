{
  lib,
  pkgs,
  self,
  config,
  ...
}:
let

  inherit (lib) mkIf;

  inherit (self.lib.modules) mkPackageOpt;

  cfg = config.sylveon.services.nginx;
in
{

  options.sylveon.services.nginx = mkPackageOpt pkgs.nginx "Manage domain stuff";

  config = mkIf cfg.enable {
    age.secrets.cloudflare-acme.rekeyFile = "${self}/secrets/cloudflare-acme.age";

    services.nginx = {
      enable = true;
      inherit (cfg) package;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };

    # Base website ports opened for nginx
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    security.acme = {
      acceptTerms = true;
      defaults.email = "d.schumin@proton.me";
      certs."xaiya.dev" = {
        domain = "*.xaiya.dev";
        dnsProvider = "cloudflare";

        group = "nginx";
        environmentFile = config.age.secrets.cloudflare-acme.path;
      };
    };
  };
}
