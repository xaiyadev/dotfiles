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
  cfg = config.${namespace}.hardware.graphics;
in {

  options.${namespace}.hardware.graphics = with types; {
    enable = mkBoolOpt false "Setup Graphics and other related settings for Nix";
  };

  config = mkIf cfg.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      # Enable Steam Configuration
      steam-hardware = enabled;
    };
  };
}
