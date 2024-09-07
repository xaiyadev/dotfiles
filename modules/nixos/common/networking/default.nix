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

        enableWIFI = mkIf {
          type = types.bool;
          default = false;
          example = true;
          description = "If wifi should be enabled with these settings";
        };
    };

    config = mkIf cfg.enable {
        networking = {
            hostName = specialArgs.host-name;
            nameservers = [ "1.1.1.1" "8.8.8.8" ];


            resolvconf = {
                enable = true;
                dnsSingleRequest = true;
            };

            firewall.enable = true;
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
                      psk = "$BLMEDIA_PASSWORD";
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
                      psk = "$HOME_PASSWORD";
                    };
                  };

                  # Mobile Hotspot
                  Pomegranate = {
                    connection = {
                      id = "Pomegranate";
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
                      ssid = "Pomegranate";
                    };
                    wifi-security = {
                      auth-alg = "open";
                      key-mgmt = "wpa-psk";
                      psk = "$HOTSPOT_PASSWORD";
                    };
                  };

                  wg_config = {
                    connection = {
                      autoconnect = "false";
                      id = "Semiko - Home";
                      interface-name = "wg_config";
                      type = "wireguard";
                      uuid = "157a62d6-a8d6-446c-a663-1c8fe20062e3";
                    };
                    ipv4 = {
                      address1 = "192.168.1.201/24";
                      dns = "192.168.1.126;192.168.1.1;";
                      dns-search = "fritz.box;";
                      method = "manual";
                    };
                    ipv6 = {
                      addr-gen-mode = "default";
                      method = "disabled";
                    };
                    proxy = { };
                    wireguard = {
                      listen-port = "51820";
                      private-key = "$VPN_KEY";
                    };
                    "wireguard-peer.Twgc0wLcy9CgMdIgMsHEW1BZcTHpGql/aQDrJFYZaiY=" = {
                      allowed-ips = "192.168.1.0/24;0.0.0.0/0;";
                      endpoint = "fl01m63nwx4c3xvz.myfritz.net:59408";
                      persistent-keepalive = "25";
                      preshared-key = "2ZIh/4CLnawfw5tpNeo3l0ON9GismlUE/Ibu/uNZ0Us=";
                      preshared-key-flags = "0";
                    };
                  };
                };
              };
            };
        };
  };
}