{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.adminerevo;
in
{
    options.services.kodi = {
        enable = mkEnableOption "custom kodi service";
    };

    config = mkIf cfg.enable {
       services.xserver = {
            enable = true;
            desktopManager.kodi.enable = true;
            lightdm.autoLogin.timeout = 3;
            displayManager = {
                autoLogin = {
                    enable = true;
                    user = "semiko";
                };
            };
       };
  };
}