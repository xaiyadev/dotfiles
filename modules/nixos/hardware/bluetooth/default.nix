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
  cfg = config.${namespace}.hardware.bluetooth;
in {

  options.${namespace}.hardware.bluetoth = with types; {
    enable = mkBoolOpt false "Whether or not to bluetooth should be enabled by the pipewire deamon";
  };

  config = mkIf cfg.enable {

  };
}