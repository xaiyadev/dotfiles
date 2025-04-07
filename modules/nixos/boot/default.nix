{ lib, config, ... }:
let
  inherit (lib.types) bool;
  inherit (lib.modules) mkOpt mkIf;

  cfg = config.sylveon.boot;
in
{
  imports = [
    ./loader # which bootloader is used
  ];

  options.sylveon.boot = {
    defaultConfiguration = mkOpt bool false "If the default configuration should be done";
  };

  config = mkIf cfg.defaultConfiguration {
    boot = {
      loader = {
        # allow installation to modify EFI variables
        efi.canTouchEfiVariables = true;
      };
    };
  };
}