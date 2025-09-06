{
  lib,
  self,
  config,
  inputs,
  ...
}:
let
  inherit (lib.modules) mkForce mkIf;
  inherit (lib.types) bool;

  inherit (self.lib.modules) mkOpt;

  prof = config.sylveon.profiles;
  cfg = config.sylveon.system.networking;
in
{

  options.sylveon.system.networking = {
    hasWifi = mkOpt bool prof.laptop.enable "Whether or not the device has wifi";
    blockMihoyoTelemetry = mkOpt bool prof.gaming.enable "If the telemetry of mihoyo games should be blocked";

    tailscale.enable = mkOpt bool true "Whether or not to enable tailscale VPN";
  };

  imports = [
    ./networkManager.nix
    ./tailscale.nix
    ./ssh.nix
  ];



  config = {
    # enable wireless database, it helps keeping wifi speedy
    hardware.wirelessRegulatoryDatabase = true;

    networking = {
      enableIPv6 = true;

      # global dhcp has been deprecated upstream, so we use networkd instead
      # however individual interfaces are still managed through dhcp in hardware configurations
      useDHCP = mkForce false;
      useNetworkd = mkForce true;

      # Disable Mihoyo telemetry if neseceary
      mihoyo-telemetry.block = cfg.blockMihoyoTelemetry;

      nameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];

    };

    # allow for the system to boot without waiting for the network interfaces are online
    systemd.network.wait-online.enable = false;
  };
}
