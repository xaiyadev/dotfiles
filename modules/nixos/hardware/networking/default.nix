{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib.modules) mkForce;
  inherit (lib.types) bool;

  inherit (self.lib.modules) mkOpt;

  prof = config.sylveon.profiles;
in
{
  imports = [
    ./networkManager.nix
    ./tailscale.nix
    ./ssh.nix
  ];

  options.sylveon.system.networking = {
    hasWifi = mkOpt bool prof.laptop.enable "Whether or not the device has wifi";

    tailscale.enable = mkOpt bool true "Whether or not to enable tailscale VPN";
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

    # allow for the system to boot without waiting for the network interfaces are online
    systemd.network.wait-online.enable = false;
  };
}
