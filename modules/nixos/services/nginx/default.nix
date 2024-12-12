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
      #age.secrets.cloudflare.rekeyFile = ./cloudflare.env.age;


      services.nginx = {
          enable = true;
          recommendedGzipSettings = true;
          recommendedOptimisation = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;
      };

      # Create cert for nginx
      security.acme = {
          acceptTerms = true;
          defaults.email = "d.schumin@proton.me";
          certs."xaiya.dev" = {
              domain = "*.xaiya.dev";
              dnsProvider = "cloudflare";

              group = "nginx";
              #environmentFile = config.age.secrets.cloudflare.path;
          };
      };
    };
}
