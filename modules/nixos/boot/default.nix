{ lib, config, self, pkgs,... }:
let
  inherit (lib.types) raw bool;
  inherit (lib.modules) mkOverride mkDefault mkForce;

  inherit (self.lib.modules) mkOpt;
  cfg = config.sylveon.system.boot;
in
{
  imports = [
    ./loader # which bootloader is used
  ];

  options.sylveon.system.boot = {
    kernel = mkOpt raw pkgs.linuxPackages_latest "The kernel for our system.";
    raidSupport = mkOpt bool false "If raid configuration should be supported.";
    tmpOnTmpfs = mkOpt bool true "Save /tmp on your ram; Dont use this if you do not have much ram!";
  };

  config = {
    boot = {
      # Use the latest linux kernel
      kernelPackages = mkOverride 500 cfg.kernel;

      # whether or not to enable raid array support
      # this throws a warning if neither MAILADDR nor PROGRAM are set
      swraid.enable = mkDefault cfg.raidSupport;

      # Add NTFS as filesystem
      supportedFilesystems = [ "ntfs" ];

      loader = {
        timeout = mkForce 5;

        # allow installation to modify EFI variables
        efi.canTouchEfiVariables = true;
      };

      tmp = {
        # Save /tmp on your ram
        useTmpfs = cfg.tmpOnTmpfs;

        # If not using tmpfs, which is naturally purged on reboot, we must clean
        # we have to clean /tmp
        cleanOnBoot = mkDefault (!config.boot.tmp.useTmpfs);
      };

      # Temporary configuration while booting the system (initial ramdisk)
      initrd = {
        availableKernelModules = [
          "nvme"
          "xhci_pci"
          "thunderbolt"
          "usbhid"
        ];

        kernelModules = [ ];
      };

      # TODO: Should I move this?
      kernelModules = [ "acpi_call" ];

      kernelParams = [
        # Fix Color accuracy in Power saving modes
        "amdgpu.abmlevel=0"
      ];
    };
  };
}