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
        virtualisation = {
            oci-containers.backend = "docker";
            docker.enable = true;
        };
    };
}
