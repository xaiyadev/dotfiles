{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.syncthingService;
in
{
    options.services.syncthingService = {
        enable = mkEnableOption "custom syncthingService service";

        asDockerContainer = mkOption {
            type = types.bool;
            default = false;
            example = true;
            description = "should this service run as a docker container or not";
        };
    };

    config = mkIf cfg.enable {
      # Syncthing ports: 8384 for remote access to GUI
      # 22000 TCP and/or UDP for sync traffic
      # 21027/UDP for discovery
      # source: https://docs.syncthing.net/users/firewall.html
      networking.firewall.allowedTCPPorts = [ 8384 22000 ];
      networking.firewall.allowedUDPPorts = [ 22000 21027 ];

      # Account will be created from service

      services.syncthing = {
          enable = !cfg.asDockerContainer;
          user = "syncthing";
          dataDir = "/mnt/raid/services/syncthing/default/";
          #configDir = "/mnt/raid/services/syncthing/config/";

          # Change that in the future
          overrideFolders = true;     # overrides any folders added or deleted through the WebUI


      };

      /* --- Docker container --- */
      virtualisation.oci-containers.containers.syncthing = mkIf cfg.asDockerContainer {
            image = "syncthing/syncthing";
            autoStart = true;
            hostname = "apricot";
            volumes =
            [
                "/mnt/raid/services/syncthing/config:/var/syncthing/config"
                "/mnt/raid/:/var/syncthing"
            ];
            ports =
            [
                "8384:8384" # Web UI
                "22000:22000/tcp" # TCP file transfers
                "22000:22000/udp" # QUIC file transfers
                "21027:21027/udp" # Receive local discovery broadcasts
            ];
      };

      /* TODO: Check wich ports to show */
      services.nginx.virtualHosts."sync.semiko.dev" = {
          addSSL = true;
          enableACME = true;
          locations."/".proxyPass = "http://[::1]:8384";
          extraConfig =
            "proxy_ssl_server_name on;";
      };
  };
}