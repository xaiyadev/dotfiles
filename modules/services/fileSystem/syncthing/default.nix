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
      systemd.services.syncthing-compose = {
          enable = cfg.asDockerContainer;
          wantedBy = ["multi-user.target"];
          after = ["docker.service" "docker.socket"];
          path = [ pkgs.docker ];

          script = ''docker compose -f ${./docker-compose.yml} up '';
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