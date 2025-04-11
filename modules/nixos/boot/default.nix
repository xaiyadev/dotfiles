{ lib, config, self, ... }:
let
  inherit (lib.types) bool;
  inherit (lib.modules) mkIf;


  inherit (self.lib.modules) mkOpt;
  cfg = config.sylveon.boot;
in
{
  imports = [
    ./loader # which bootloader is used
  ];

  options.sylveon.boot = {
    loadRecommendedConfiguration = mkOpt bool false "If the default configuration should be done";
  };

  config = mkIf cfg.loadRecommendedConfiguration {
    boot = {
      # Add NTFS as filesystem
      supportedFilesystems = [ "ntfs" ];

      # allow installation to modify EFI variables
      loader.efi.canTouchEfiVariables = true;
    };
  };
}