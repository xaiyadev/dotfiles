{ lib, self, ... }:
let
  inherit (lib.modules) mkForce;
  inherit (lib.types) bool;

  inherit (self.lib.modules) mkOpt;
in
{
  imports = [
    ./networkManager.nix
    ./tailscale.nix
    ./ssh.nix
  ];


  options.sylveon.system.networking = {
    hasWifi =
      mkOpt bool true "Whether or not the device has wifi";

    tailscale.enable =
      mkOpt bool true "Whether or not to enable tailscale VPN";
  };

  config = {
    # enable wireless database, it helps keeping wifi speedy
    hardware.wirelessRegulatoryDatabase = true;

    networking = {
      enableIPv6 = true;

       # global dhcp has been deprecated upstream, so we use networkd instead
       # however individual interfaces are still managed through dhcp in hardware configurations
       useDHCP = mkForce false;
       useNetworkd = mkForce true;

      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];

    };
  };
}