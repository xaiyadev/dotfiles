{ config, lib, ... }:
with lib;
let
    cfg = config.services.locale;
in
{
    options.services.locale = {
        enable = mkEnableOption "custom locale service";
    };

    config = mkIf cfg.enable {
        console.keyMap = "de";

        time.timeZone = "Europe/Berlin";

        i18n.defaultLocale = "en_US.UTF-8";
        i18n.extraLocaleSettings = {
            LC_ADDRESS = "de_DE.UTF-8";
            LC_IDENTIFICATION = "de_DE.UTF-8";
            LC_MEASUREMENT = "de_DE.UTF-8";
            LC_MONETARY = "de_DE.UTF-8";
            LC_NAME = "de_DE.UTF-8";
            LC_NUMERIC = "de_DE.UTF-8";
            LC_PAPER = "de_DE.UTF-8";
            LC_TELEPHONE = "de_DE.UTF-8";
            LC_TIME = "de_DE.UTF-8";
        };


        services.xserver.xkb.layout = "de";
  };
}