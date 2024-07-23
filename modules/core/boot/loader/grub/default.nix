{ config, lib, ... }:
with lib;
let
    cfg = config.services.grub;
in
{
    options.services.grub = {
        enable = mkEnableOption "custom grub service";
    };

    config = mkIf cfg.enable {
        boot.supportedFilesystems = [ "ntfs" ];
        boot.loader = {
        efi.canTouchEfiVariables = true;

        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          useOSProber = true;
        };
      };
  };
}