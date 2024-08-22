{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.adminerevo;
in
{
    options.services.adminerevo = {
        enable = mkEnableOption "custom adminerevo service";
    };

    config = mkIf cfg.enable {
        # Adminer will only be accessable in local network
        # TODO: learn where it is saved etc.
        environment.systemPackages = with pkgs; [ adminerevo ];
  };
}