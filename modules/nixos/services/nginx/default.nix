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
    cfg = config.${namespace}.services.nginx;
in
{
    options.${namespace}.services.nginx = {
        enable = mkEnableOption "Setup NGINX server. For the other services to work you need this enabled!";
        enable-acme = mkOption {
          type = types.bool;
          default = true;
          description = "Use Lix instead of Nix";
        };

    };

    config = mkIf cfg.enable {
        # Load keys
        age.secrets.cloudflare.file = ../../../../secrets/cloudflare.env.age;


        networking.firewall.allowedTCPPorts = [ 80 443 ];

        services.nginx = {
            enable = true;
            recommendedGzipSettings = true;
            recommendedOptimisation = true;
            recommendedProxySettings = true;
            recommendedTlsSettings = true;
        };

        # Create cert for nginx
        security.acme = mkIf cfg.enable-acme {
            acceptTerms = true;
            defaults.email = "danil80sch@gmail.com";
            certs."semiko.dev" = {
                domain = "*.semiko.dev";
                dnsProvider = "cloudflare";

                group = "nginx";
                environmentFile = config.age.secrets.cloudflare.path;
            };
        };
    };
}
