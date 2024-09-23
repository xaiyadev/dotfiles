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
    cfg = config.${namespace}.services.vaultwarden;
in
{
    options.${namespace}.services.vaultwarden = {
        enable = mkEnableOption "Personalized Password Manager!";

    };

    config = mkIf cfg.enable {
      age.secrets.vaultwarden.file = ../../../../secrets/vaultwarden.env.age;


      virtualisation.oci-containers.containers.vaultwarden = {
            image = "vaultwarden/server";
            autoStart = true;
            hostname = "apricot";
            volumes =
                [
                    "/mnt/raid/services/vaultwarden/data:/data:rw"
                    #"/mnt/raid/services/vaultwarden/web-vault:/web-vault:rw"
                ];
            ports =
                [
                    "9445:80" # WEB-UI
                ];

            environmentFiles = [
                config.age.secrets.vaultwarden.path
            ];
      };



      networking.firewall.allowedTCPPorts = [ 9445 ];
      services.nginx.virtualHosts."vault.semiko.dev" = {
        forceSSL = true;
        useACMEHost = "semiko.dev";
        locations."/".proxyPass = "http://[::1]:9445";
        extraConfig = "proxy_ssl_server_name on;";
      };
    };
}
