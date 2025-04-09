{ lib, config, ...}:
let
  inherit (lib.types) str;
  inherit (lib.modules) mkOpt mkIf;

  cfg = config.sylveon.boot.loader;
in
{

  options.sylveon.boot.grub = {
    device = mkOpt str "nodev" "The device that the bootloader should be installed on.";
  };

  config = mkIf (cfg.loader == "grub") {
    boot.loader.grub = {
      inherit (cfg.grub) device;
      enable = true;

      efiSupport = true;
      useOSProber = true;

      theme = null; # TODO: add astronaut theme
    };
  };
}