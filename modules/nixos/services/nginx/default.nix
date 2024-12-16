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
with lib.${namespace};
let
    cfg = config.${namespace}.services.nginx;
in
{
    options.${namespace}.services.nginx = with types; {
        enable = mkBoolOpt false "Wheter or not to enable the nginx service for domain and port managing";
    };

    config = mkIf cfg.enable {
      # Load the cloudflare environment files
      age.secrets.cloudflare.rekeyFile = "${inputs.self}/secrets/cloudflare.env.age";


      services.nginx = {
          enable = true;
          recommendedGzipSettings = true;
          recommendedOptimisation = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;
      };

      # Create cert for nginx
      networking.firewall.allowedTCPPorts = [ 80 443 ];
      security.acme = {
          acceptTerms = true;
          defaults.email = "d.schumin@proton.me";
          certs."xaiya.dev" = {
              domain = "*.xaiya.dev";
              dnsProvider = "cloudflare";

              group = "nginx";
              environmentFile = config.age.secrets.cloudflare.path;
          };
      };

      /*
      * Adding temporary filter before adding a main start page
      * This will also be a small "linktree", my socials in one place
      */
      services.nginx.virtualHosts."xaiya.dev" = {
        forceSSL = true;
        useACMEHost = "xaiya.dev";
        locations."/".return = ''301 https://catpedia.wiki/Category:Cat''; # Return to a cool catpedia page

        /* Return to social media platforms */
        locations."/bsky".return = "301 https://bsky.app/profile/xaiya.dev";
        locations."/git".return = "301 https://github.com/xaiyadev";

        extraConfig = "proxy_ssl_server_name on;";
      };
    };
}
