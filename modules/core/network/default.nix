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
            default = "huckleberry";
        };
    };

    config = mkIf cfg.enable {

        networking = {
            hostName = cfg.hostName;

            firewall.enable = true;

            networkmanager.enable = true;

            nameservers = [ "1.1.1.1" "8.8.8.8" ];

            resolvconf = {
                enable = true;
                dnsExtensionMechanism = false;
                useLocalResolver = false;
                dnsSingleRequest = true;
            };
        };
    };
}
