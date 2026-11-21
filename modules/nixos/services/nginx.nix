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
  options.sylveon.services.nginx = {
    enable = mkEnableOption "Enable Nginx proxy";
    public = mkEnableOption "listening on every interface and opening 80/443, instead of only the tailnet";
  };

  config = mkIf cfg.enable {
    age.secrets.cloudflare-acme.rekeyFile = "${self}/secrets/cloudflare-acme.age";

    users.users.nginx.extraGroups = [ "acme" ];

    networking.firewall.allowedTCPPorts = mkIf cfg.public [
      80
      443
    ];

    services.nginx = {
      enable = true;

      # only bind to tailnet (tailscale) (should rewrite this into more detail for tailscale? TODO)
      defaultListenAddresses = mkIf (!cfg.public) [ "100.111.243.3" ];

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # landing page for the tailnet only
      virtualHosts."xaiya.dev" = mkIf (!cfg.public) {
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
        dnsResolver = "1.1.1.1:53"; # use cloudflares dns-resolver instead of the systems one
        webroot = null;

        environmentFile = config.age.secrets.cloudflare-acme.path;
      };
    };
  };
}
