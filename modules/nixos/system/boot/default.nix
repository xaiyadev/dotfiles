{
  lib,
  pkgs,
  inputs,

  namespace,
  system,
  target,
  format,
  virtual,
  systems,

  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.system.boot;
in {

  options.${namespace}.system.boot =  with types; {
    enable = mkBoolOpt false "Wheter or not to enable booting";
    windows.enable = mkBoolOpt false "If the boot loader (grub) should search for windows instances"; # Should be removed with huckleberry

  };

  config = mkIf cfg.enable {
    boot = {
      supportedFilesystems = if cfg.windows.enable then [ "ntfs" ] else [];

      loader = {
        efi.canTouchEfiVariables = true;

        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev"; # No grub environment will be installed localy

          useOSProber = cfg.windows.enable;
        };
      };
    };
  };
}