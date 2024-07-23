{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.phpstorm;
in
{
    options.services.phpstorm = {
        enable = mkEnableOption "custom phpstorm service";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            jetbrains.phpstorm
        ];
    };
}