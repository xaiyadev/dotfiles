{ lib, config, self, ...}:
let
  inherit (lib.types) str;
  inherit (lib.modules) mkIf;

  inherit (self.lib.modules) mkOpt;

  cfg = config.sylveon.boot;
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