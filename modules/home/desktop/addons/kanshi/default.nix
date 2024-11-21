{
  lib,
  pkgs,
  inputs,

  namespace,
  target,
  format,
  virtual,
  host,

  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.desktop.addons.kanshi;
in {

  options.${namespace}.desktop.addons.kanshi = with types; {
    enable = mkBoolOpt false "Whether or not to enable Kanshi as a monitor manager";
  };

  config = mkIf cfg.enable {
    services.kanshi = {
      enable = true;
    };
  };
}
