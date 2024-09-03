{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.docker;
in
{
    options.services.docker = {
        enable = mkEnableOption "custom dockerservice";
    };

    config = mkIf cfg.enable {
        virtualisation.docker = {
            enable = true;
            enableOnBoot = true;
        };
    };
}
