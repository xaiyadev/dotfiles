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
      environment.systemPackages = with pkgs; [
        adminerevo
      ];
  };
}