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
    cfg = config.${namespace}.services.youtrack;
in
{
    options.${namespace}.services.youtrack = {
        enable = mkEnableOption "Issues platform for tracking issues :3";

    };

    config = mkIf cfg.enable {
      /* age.secrets.youtrack.file = ../../../../secrets/youtrack.env.age; */


      virtualisation.oci-containers.containers.youtrack = {
            image = "jetbrains/youtrack:2024.3.44799";
            volumes =
                [
                  "/mnt/raid/services/youtrack/database:/opt/youtrack/data:rw"
                  "/mnt/raid/services/youtrack/configuration:/opt/youtrack/conf:rw"
                ];
            ports =
                [
                    "2266:8080"
                ];
      };



      networking.firewall.allowedTCPPorts = [ 2266 ];
      services.nginx.virtualHosts."issues.semiko.dev" = {
        forceSSL = true;
        useACMEHost = "semiko.dev";
        locations."/".proxyPass = "http://[::1]:2266";
        extraConfig = "proxy_ssl_server_name on;";
      };
    };
}
