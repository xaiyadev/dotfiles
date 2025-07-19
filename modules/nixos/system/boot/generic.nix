{ lib, config, self, pkgs,... }:
let
  inherit (lib.types) raw bool;
  inherit (lib)
    mkOverride
    mkDefault
    mkForce
    optionals
    ;

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

      kernelParams =
        optionals cfg.profiles.laptop.enable [
          # allow systemd to set and save the backlight state
          "acpi_backlight=native"

          # Fix Color accuracy in Power saving modes
          "amdgpu.abmlevel=0"
        ];

      initrd = {
        verbose = false;
        systemd.enable = true;

        kernelModules = [
          "nvme"
          "xhci_pci"
          "ahci"
          "sd_mod"
        ];

        availableKernelModules = [
          "usbhid" # supports USB keyboards, mice, gamepads, etc.
          "sd_mod" # For STA and NVMe drives
          "sr_mod" # boot from or access optical media
          "uas" # Better performance for USB 3.0
          "usb_storage" # Enables USB storage devices
        ];
      };
    };
  };
}
