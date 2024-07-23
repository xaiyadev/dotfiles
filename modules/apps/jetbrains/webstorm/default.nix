{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.webstorm;
in
{
    options.services.webstorm = {
        enable = mkEnableOption "custom webstorm service";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            jetbrains.webstorm
        ];
    };
}