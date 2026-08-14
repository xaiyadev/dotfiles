{ lib, config, ... }:
let
  inherit (lib) mkMerge mkDefault mkEnableOption mkIf mkOption;
  inherit (lib.types) bool listOf string;

  inherit (config.services) tailscale;

  cfg = config.sylveon.networking.tailscale;
  prof = config.sylveon.profiles;
in
{

  options.sylveon.networking.tailscale = {
    enable = mkEnableOption "Tailscale VPN" // {
      default = true;
    };

    isServer = mkOption {
      type = bool;
      default = prof.server.enable;
      description = ''
        Whether this tailscale device is a server or not
      '';
    };

    upFlags = mkOption {
      type = (listOf string);
      default = [ "" ];
      description = ''
        Which up flags to insert into tailscale      
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      networking.firewall = {
        trustedInterfaces = [ "${tailscale.interfaceName}" ];
        checkReversePath = "loose";
      
        allowedUDPPorts = [ tailscale.port ];
      };
      
      services.tailscale = {
          enable = true;
            
          permitCertUid = "root";
          useRoutingFeatures = if cfg.isServer then "server" else "client";
            
          extraUpFlags = cfg.upFlags ++ [ "--ssh" ];
        };
    }

    (mkIf cfg.isServer { # TODO move?
      # add a dnsmasq for the tailscale network
      services.dnsmasq = {
        enable = true;
          
        settings = {
          listen-address = [ "100.111.243.3" ]; # apricot (server ip) should this be set as an option? TODO
          bind-interfaces = true;
          
          address = [ "/xaiya.dev/100.111.243.3" ];
          no-resolv = true;
        };
      };

      systemd.services.dnsmasq = {
        after = [ "tailscaled.service" ];
        requires = [ "tailscaled.service" ];
      };
    })


  ]);
}
