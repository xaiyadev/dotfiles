{ config, lib, ... }:
with lib;
let
    cfg = config.services.network;
in
{
    options.services.network = {
        enable = mkEnableOption "custom network service";
        hostName = mkOption {
            type = types.str;
            default = "nixos-tower";
        };
    };

    config = mkIf cfg.enable {
          environment.etc = {
            "resolv.conf".text = "nameserver 1.1.1.1\nnameserver 8.8.8.8"; /* Only fix right now, else it would add automaticly not wanted DNS */
          };

        networking = {
            hostName = cfg.hostName;

            firewall.enable = true;

            networkmanager = {
                enable = true;
                dns = "none";
            };

            resolvconf = {
                enable = true;
                dnsExtensionMechanism = false;
                useLocalResolver = false;
                dnsSingleRequest = true;
            };
        };
    };
}