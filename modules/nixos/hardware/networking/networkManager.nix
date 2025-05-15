{ config, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.sylveon.system.networking;
in
{

  config = {
    networking.networkmanager = {
      enable = true;
      dns = "systemd-resolved";

      wifi = mkIf cfg.hasWifi {
        backend = "wpa_supplicant";

        powersave = true;
        scanRandMacAddress = true;

      };
    };
  };

}