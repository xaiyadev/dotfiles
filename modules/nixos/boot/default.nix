{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkDefault;

  cfg = config.sylveon.boot;
in
{
  imports = [
    ./loader.nix # Boot loader to use
    ./loginManager.nix # TODO: move
  ];

  options.sylveon.boot = {
    raid.enable = mkEnableOption "Whether or not raid paritions should be enabled or not";
    tmpOnTmpfs = mkEnableOption "/tml living on tmpfs. false menas it will be cleared each reboot" // {
      default = true;
    };
  };

  config.boot = {
    consoleLogLevel = 3; # only show errors and emergency alerts

    swraid.enable = cfg.raid.enable;

    tmp = {
      # Save /tmp on your ram
      useTmpfs = cfg.tmpOnTmpfs;

      # If not using tmpfs, which is naturally purged on reboot, we must clean
      # we have to clean /tmp
      cleanOnBoot = mkDefault (!config.boot.tmp.useTmpfs);
    };

    initrd = {
      verbose = false;
      systemd.enable = true;

      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "thunderbolt"

        "usbhid" # supports USB keyboards, mice, gamepads, etc.
        "sd_mod" # For STA and NVMe drives
        "sr_mod" # boot from or access optical media
        "uas" # Better performance for USB 3.0
        "usb_storage" # Enables USB storage devices
      ];
    };
  };
}
