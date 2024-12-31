{ config, lib, pkgs, modulesPath, ... }:

{
  /* --- Manual Added code --- */

  /* Install and configure NVIDIA drivers */
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics = {
      enable = true;

      extraPackages = with pkgs; [ vulkan-validation-layers ];
    };

    nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.beta;

        modesetting.enable = true;
        powerManagement.enable = true;

        nvidiaPersistenced = true;

        open = true;
        nvidiaSettings = true;
      };
  };

  /* Adding NTFS filesystem */
  fileSystems."/mnt/win10" =
    {
      device = "/dev/disk/by-uuid/60BCF29FBCF26EC2";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" "gid=100" "user" "exec" "umask=000" ]; # important: change uid and gid to the right numbers :D
    };

  fileSystems."/mnt/games" =
    {
      device = "/dev/disk/by-uuid/F4462E50462E13C0";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" "gid=100" "user" "exec" "umask=000" ]; # important: change uid and gid to the right numbers :D
    };



  /* --- Auto generated code --- */
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
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