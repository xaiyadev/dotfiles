{ lib, ... }:
with lib;
rec {

  /*
   *  Create a Wifi profile that is based on my default network profile
   *
   *  ```nix
   *  mkWifiProfile { "network"; "00000000-0000-0000-0000-000000000000"; "$password" }
   *  ```
   */
  mkWifiProfile =
    network: uuid: password:
    {
      connection = {
        id = "${network}";
        interface-name = "wlp3s0"; # all my connections use this interface, so no option created
        type = "wifi";
        uuid = "${uuid}";
      };

      ipv4 = {
        ignore-auto-dns = true;
        method = "auto";
      };

      ipv6.method = "auto";

      wifi = {
        mode = "infrastrcture";
        ssid = "${network}";
      };

      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-psk";
        psk = "${password}";
      };
    };


  /*
   *  Create a Wifi profile with a peap profile authitication
   *
   *  ```nix
   *  mkWifiProfile { "network"; "00000000-0000-0000-0000-000000000000"; } { "$identity" "$password" }
   *  ```
   */
  mkWifiPeapProfile =
    network: uuid: { identity, password }:
    {
        "802-1x" = {
          eap = "peap;";
          identity = "${identity}";
          password = "${password}";
          phase2-auth = "mschapv2";
        };

        connection = {
          id = "${network}";
          interface-name = "wlp3s0"; # all my connections use this interface, so no option created
          type = "wifi";
          uuid = "${uuid}";
        };

        ipv4 = {
          ignore-auto-dns = true;
          method = "auto";
        };

        ipv6.method = "auto";

        wifi = {
          mode = "infrastructure";
          ssid = "${network}";
        };

        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-eap";
        };
    };
}