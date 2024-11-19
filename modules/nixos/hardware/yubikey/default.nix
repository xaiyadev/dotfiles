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
  cfg = config.${namespace}.hardware.yubikey;
in {

  options.${namespace}.hardware.yubikey = with types; {
    enable = mkBoolOpt false "Whether or not to enable the yubikey configuration and support";
  };

  /*  Before Yubikey can complety work on the system, you need to manually configure some things.
   *  Look at the installation instructions in the README
   */
  config = mkIf cfg.enable {

  };
}
