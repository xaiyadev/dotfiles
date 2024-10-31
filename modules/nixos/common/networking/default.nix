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
let
    cfg = config.${namespace}.common.networking;
in
{
    options.${namespace}.common.networking = {
        enable = mkEnableOption "Setup Locale settings; time/keyboard etc.";

        vpn.enable = mkEnableOption ''If the local VPN from the 'frit.box' should be activated'';
    };

    config = mkIf cfg.enable {
        # Load keys
        age.secrets = {
          wifi-profiles.file = ../../../../secrets/wifi-profiles.env.age;

          wg-vpn.file = ../../../../secrets/wg-vpn.key.age;
          wg-vpn-paired.file = ../../../../secrets/wg-vpn.paired-key.age;
        };

        /* Only fix right now, else it would add automaticly not wanted DNS */
        environment.etc."resolv.conf".text =  "nameserver 1.1.1.1\nnameserver 8.8.8.8\noptions single-request edns0";
        networking = {
/*            resolvconf = {
                enable = true;
                dnsSingleRequest = true;
            };*/


            hostName = specialArgs.host-name;
            nameservers = [ "1.1.1.1" "8.8.8.8" ];


            firewall = {
              enable = true;
              allowedUDPPorts = [ 51820 ];
              checkReversePath = mkIf cfg.vpn.enable "loose";
            };

            networkmanager = {
              enable = true;
              ensureProfiles = {
                environmentFiles = [ config.age.secrets.wifi-profiles.path ];
                profiles = {
                  # Work Network
                  BLmedia = {
                    connection = {
                      id = "BLmedia";
                      interface-name = "wlp3s0";
                      type = "wifi";
                      uuid = "840919d9-2b91-41a3-b208-a35e63fff999";
                    };
                    ipv4 = {
                      method = "auto";
                    };
                    ipv6 = {
                      addr-gen-mode = "default";
                      method = "auto";
                    };
                    proxy = { };
                    wifi = {
                      mode = "infrastructure";
                      ssid = "BLmedia";
                    };
                    wifi-security = {
                      auth-alg = "open";
                      key-mgmt = "wpa-psk";
                      psk = "$BLMEDIA";
                    };
                  };

                  # School Network
                  BTA-Schueler = {
                    "802-1x" = {
                      eap = "peap;";
                      identity = "$BTA_IDENTITY";
                      password = "$BTA_PASSWORD";
                      phase2-auth = "mschapv2";
                    };
                    connection = {
                      id = "BTA-Schueler";
                      interface-name = "wlp3s0";
                      type = "wifi";
                      uuid = "565d854e-8195-4b29-b91f-9e6f783ea4f5";
                    };
                    ipv4 = {
                      method = "auto";
                    };
                    ipv6 = {
                      addr-gen-mode = "default";
                      method = "auto";
                    };
                    proxy = { };
                    wifi = {
                      mode = "infrastructure";
                      ssid = "BTA-Schueler";
                    };
                    wifi-security = {
                      auth-alg = "open";
                      key-mgmt = "wpa-eap";
                    };
                  };

                  # Home network
                  "FRITZ!Box 6660 Cable JS 5 GHz" = {
                    connection = {
                      id = "FRITZ!Box 6660 Cable JS 5 GHz";
                      interface-name = "wlp3s0";
                      timestamp = "1714742793";
                      type = "wifi";
                      uuid = "c67ace98-35a3-4542-b370-eae9a7446c9a";
                    };
                    ipv4 = {
                      dns = "1.1.1.1;8.8.8.8;";
                      ignore-auto-dns = "true";
                      method = "auto";
                    };
                    ipv6 = {
                      addr-gen-mode = "default";
                      method = "auto";
                    };
                    proxy = { };
                    wifi = {
                      mode = "infrastructure";
                      ssid = "FRITZ!Box 6660 Cable JS 5 GHz";
                    };
                    wifi-security = {
                      key-mgmt = "wpa-psk";
                      psk = "$HOME";
                    };
                  };

                  # Mobile Hotspot
                  Strawberry = {
                    connection = {
                      id = "Stawberry";
                      interface-name = "wlp3s0";
                      type = "wifi";
                      uuid = "1f08f24d-56fc-46e2-bdca-39f553b6410d";
                    };
                    ipv4 = {
                      method = "auto";
                    };
                    ipv6 = {
                      addr-gen-mode = "default";
                      method = "auto";
                    };
                    proxy = { };
                    wifi = {
                      mode = "infrastructure";
                      ssid = "Strawberry";
                    };
                    wifi-security = {
                      auth-alg = "open";
                      key-mgmt = "wpa-psk";
                      psk = "$HOTSPOT";
                    };
                  };
                };
              };
            };

            wg-quick.interfaces = mkIf cfg.vpn.enable {
              wg0 = {
                address = [ "192.168.1.201/24" ];
                listenPort = 51820;
                privateKeyFile = config.age.secrets.wg-vpn.path;
                autostart = false;

                peers = [{
                  publicKey = "Twgc0wLcy9CgMdIgMsHEW1BZcTHpGql/aQDrJFYZaiY=";
                  allowedIPs = [ "192.168.1.0/24" "0.0.0.0/0" ];
                  endpoint = "fl01m63nwx4c3xvz.myfritz.net:59408";
                  presharedKeyFile = config.age.secrets.wg-vpn-paired.path;
                  persistentKeepalive = 25;
                }];
              };
            };
        };

  };
}
