{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.sylveon.services.nginx;
in
{
  options.sylveon.services.nginx.enable = mkEnableOption "Enable Nginx proxy";

  config = mkIf cfg.enable {
    age.secrets.cloudflare-acme.rekeyFile = "${self}/secrets/cloudflare-acme.age";

    users.users.nginx.extraGroups = [ "acme" ];

    services.nginx = {
      enable = true;

      # only bind to tailnet (tailscale) (should rewrite this into more detail for tailscale? TODO)
      defaultListenAddresses = [ "100.111.243.3" ];

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."xaiya.dev" = {
        useACMEHost = "xaiya.dev";
        forceSSL = true;

        locations."/" = {
          return = "200 '<html><body>Loaded into the tailscale network correctly !</body></html>'";
          extraConfig = ''
            default_type text/html;
          '';
        };

        extraConfig = "proxy_ssl_server_name on;";
      };
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "d.schumin@proton.me";

      certs."xaiya.dev" = {
        group = "nginx";

        domain = "*.xaiya.dev";
        extraDomainNames = [ "xaiya.dev" ]; # Using this because *. doesnt take the original

        dnsProvider = "cloudflare";
        webroot = null;

        environmentFile = config.age.secrets.cloudflare-acme.path;
      };
    };
  };
}
