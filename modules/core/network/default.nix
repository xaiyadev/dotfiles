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

	    hosts = {
      		"0.0.0.0" = [
        		"overseauspider.yuanshen.com"
        		"log-upload-os.hoyoverse.com"
        		"log-upload-os.mihoyo.com"
        		"dump.gamesafe.qq.com"

        		"log-upload.mihoyo.com"
        		"devlog-upload.mihoyo.com"
        		"uspider.yuanshen.com"
        		"sg-public-data-api.hoyoverse.com"
        		"public-data-api.mihoyo.com"

        		"prd-lender.cdp.internal.unity3d.com"
        		"thind-prd-knob.data.ie.unity3d.com"
        		"thind-gke-usc.prd.data.corp.unity3d.com"
        		"cdp.cloud.unity3d.com"
        		"remote-config-proxy-prd.uca.cloud.unity3d.com"
     		 ];
    };

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
