{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ./fileSystem.nix
  ];

  networking.hostName = "pineapple";

  # TODO
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;

  # Network configuration for Waydroid
  networking.firewall.trustedInterfaces = [ "waydroid0" ];
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  sylveon = {
    profiles = {
      graphical.enable = true;
      gaming.enable = true;
      laptop.enable = true;
    };

    device = {
      cpu = "amd";
      gpu = "amd";
    };

    system = {
      users = [
        "xaiya"
        "blmedia"
      ];
    };

    services = {
      docker.enable = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
