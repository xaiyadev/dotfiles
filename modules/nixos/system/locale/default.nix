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
  cfg = config.${namespace}.system.locale;
in {

  options.${namespace}.system.locale = with types; {
    enable = mkBoolOpt false "Wheter or not to manage locale settings";
  };

  config = mkIf cfg.enable {
    console.keyMap = mkForce "de";

    time.timeZone = "Europe/Berlin";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADRESS = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };
    };
  };
}
