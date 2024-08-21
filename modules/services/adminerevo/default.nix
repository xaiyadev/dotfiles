{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.adminerevo;
in
{
    options.services.adminerevo = {
        enable = mkEnableOption "custom adminerevo service";
    };

    # TODO: continue coding!
    config = mkIf cfg.enable {
      services.adminer = {
        enable = true;
        package = pkgs.adminerevo;
      };
      environment.systemPackages = with pkgs; [ adminerevo ];
  };
}