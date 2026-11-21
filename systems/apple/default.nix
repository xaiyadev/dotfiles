{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  imports = [
    ./fileSystem.nix
  ];

  networking.hostName = "apple";

  sylveon = {
    profiles.server.enable = true;

    users = [ "xaiya" ];

    # vps boots via BIOS
    boot = {
      efi.enable = false;
      device = "/dev/vda";
    };

    # the dnsmasq belongs to apricot; this vps is only a client
    networking.tailscale.isServer = false;

    services = {
      nginx = {
        enable = true;
        public = true; # Our vps handles the public traffic
      };

      # -- services
      pds.enable = true;
    };
  };

  # this is a public vps; ssh is only reachable through the tailscale vpn
  services.openssh.openFirewall = mkForce false;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
