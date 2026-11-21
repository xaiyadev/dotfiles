{ lib, config, ... }:
let
  inherit (lib) mkForce mkOption mkEnableOption;
  inherit (lib.types) enum str;

  cfg = config.sylveon.boot;
in
{
  options.sylveon.boot = {
    loader = mkOption {
      type = enum [ "grub" ];
      default = "grub";
    };

    efi.enable = mkEnableOption "Whether or not to boot with UEFI or BIOS" // {
      default = true;
    };

    device = mkOption {
      type = str;
      default = "nodev";
      example = "/dev/vda";
      description = ''
        Disk grub gets installed into. 
        "nodev" only installs the EFI binary
      '';
    };
  };

  config = {
    boot.loader = {
      timeout = mkForce 5; # Timeout after 5 seconds

      efi.canTouchEfiVariables = cfg.efi.enable;

      grub = {
        enable = cfg.loader == "grub";
        inherit (cfg) device;

        configurationLimit = 3;

        useOSProber = true;
        efiSupport = cfg.efi.enable;
      };
    };
  };
}
