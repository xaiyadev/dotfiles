{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.vesktop;
in
{
    options.services.vesktop = {
        enable = mkEnableOption "custom vesktop service";
    };

    config = mkIf cfg.enable {
         home.file.".config/vesktop/themes.mocha.theme.css".source = ./themes/mocha.theme.css;

        home.packages = with pkgs; [
            vesktop
        ];
    };
}