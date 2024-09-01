{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.syncthingService;
in
{
    options.services.syncthingService = {
        enable = mkEnableOption "custom syncthingService service";
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
          enable = true;
          user = "syncthing";
          dataDir = "/mnt/raid/services/syncthing/default/";
          #configDir = "/mnt/raid/services/syncthing/config/";

          # Change that in the future
          overrideDevices = true;     # overrides any devices added or deleted through the WebUI
          overrideFolders = true;     # overrides any folders added or deleted through the WebUI


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