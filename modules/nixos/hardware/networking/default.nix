{
  lib,
  pkgs,
  inputs,

  namespace,
  system,
  target,
  format,
  virtual,
  systems,

  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.networking;
in {

  options.${namespace}.hardware.networking = with types; {
    enable = mkBoolOpt false "Wheter or not to install all network settings";
    wifi.ensureProfiles.enable = mkBoolOpt false "Whether or not to ensure if profiles exists";
    vpn.enable = mkBoolOpt false "Whether or not to enable my home based vpn";
  };

  config = mkIf cfg.enable {
    # Enable all age-passwords
    #age.secrets.networking-profiles.rekeyFile = ./networking-profiles.env.age; TODO: Enable passwords after age is configured

    networking = {
      resolvconf = {
        enable = true;
        # Fix IPv6 DNS request load times
        dnsSingleRequest = true;
      };

      networkmanager = {
        enable = true;

        /* Wifi Profiles */
        ensureProfiles = mkIf cfg.wifi.ensureProfiles.enable {
          # environmentFiles = [ config.age.secrets.networking-profiles.path ];
          profiles = {
            BLmedia =
              mkWifiProfile "BLmedia" "840919d9-2b91-41a3-b208-a35e63fff999" "$BLMEDIA";

            BTA-Schueler =
              mkWifiPeapProfile "BTA-Schueler" "565d854e-8195-4b29-b91f-9e6f783ea4f5" { identity = "$BTA_USER"; password = "$BTA_PASSWORD"; };

            "FRITZ!Box 6660 Cable JS 5 GHz" =
              mkWifiProfile "FRITZ!Box 6660 Cable JS 5 GHz" "c67ace98-35a3-4542-b370-eae9a7446c9a" "$FRITZ_BOX";

            Strawberry =
              mkWifiProfile "Strawberry" "1f08f24d-56fc-46e2-bdca-39f553b6410d" "$STRAWBERRY";
          };
        };
      };

      /* VPNs */
      wg-quick.interfaces = mkIf cfg.vpn.enable {
        wg0 = {
          address = [ "192.168.1.201/24" ];
          listenPort = 51820;
          #privateKeyFile = config.age.secrets.networking-vpn-privateKey.path;
          autostart = false;

          peers = [{
            publicKey = "Twgc0wLcy9CgMdIgMsHEW1BZcTHpGql/aQDrJFYZaiY=";
            allowedIPs = [ "192.168.1.0/24" "0.0.0.0/0" ];
            endpoint = "fl01m63nwx4c3xvz.myfritz.net:59408";
            # presharedKeyFile = config.age.secrets.networking-vpn-preSharedKey.path
            persistentKeepalive = 25;
          }];
        };
      };
    };
  };
}
