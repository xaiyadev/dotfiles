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

      # services
      pds.enable = true;
    };
  };

  # this is a public vps, we dont want others to ssh into it ( TODO: make this a public option? no ssh in general for public address?)
  services.openssh.openFirewall = mkForce false;

  # only ipv4 is used  TODO: set as option?
  # -> disabled in the kernel, so networkmanager can't turn it back on
  boot.kernelParams = [ "ipv6.disable=1" ];
  networking.enableIPv6 = false; 

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
