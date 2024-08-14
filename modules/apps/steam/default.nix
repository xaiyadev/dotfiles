{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.steam;
in
{
    options.services.steam = {
        enable = mkEnableOption "custom steam service";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [ steam ];
    };
}