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
    cfg = config.${namespace}.services.vaultwarden;
in
{
    options.${namespace}.services.syncthing = with types; {
        enable = mkBoolOpt false "Wheter or not to enable the vaultwarde service for password managment";
    };

    config = mkIf cfg.enable {

      virtualisation.oci-containers.containers.syncthing = {
            image = "syncthing/syncthing";
            autoStart = true;
            hostname = "apricot";

            volumes = [
              "/mnt/raid/services/syncthing/:/var/syncthing:rw"
            ];

            ports = [ 
              "8384:8384" # Web UI
              "22000:22000/tcp" # TCP File transfer
              "22000:22000/udp" # QUIC file transfer
              "21027:21027/udp" # Receive local discovery broadcasts
            ];

            environmentFiles = [
                # config.age.secrets.syncthing.path TODO: configure age secrets
            ];
      };

      networking.firewall.allowedTCPPorts = [ 8384 22000 ];
      networking.firewall.allowedUDPPorts = [ 22000 21027 ];
      services.nginx.virtualHosts."files.semiko.dev" = {
        forceSSL = true;
        useACMEHost = "semiko.dev";
        locations."/".proxyPass = "http://[::1]:8384";
        extraConfig = "proxy_ssl_server_name on;";
      };
    };
}
