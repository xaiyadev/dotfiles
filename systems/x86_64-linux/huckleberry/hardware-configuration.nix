# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  # Installing NVIDIA drivers TODO: find a good fix
  
  services.xserver.videoDrivers = [ "nouveau" ];

  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "nouveau" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f972b765-8131-4fc8-9004-5bea1624e0d7";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8A70-A023";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/mnt/win10" =
    {
      device = "/dev/disk/by-uuid/A40897C408979440";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" "gid=100" "user" "exec" "umask=000" ]; # important: change uid and gid to the right numbers :D
    };

  fileSystems."/mnt/games" =
    {
      device = "/dev/disk/by-uuid/F4462E50462E13C0";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" "gid=100" "user" "exec" "umask=000" ]; # important: change uid and gid to the right numbers :D
    };



  swapDevices = [ { device = "/dev/disk/by-uuid/447ff942-7036-4cac-9d81-f08e1798b577"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp8s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
