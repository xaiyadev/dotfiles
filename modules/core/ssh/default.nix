{ config, lib, ... }:
with lib;
let
    cfg = config.services.ssh;
in
{
    options.services.ssh = {
        enable = mkEnableOption "custom ssh service";
    };

    config = mkIf cfg.enable {
        services.openssh = {
            enable = true;
            banner = " Welcome to Breakings System! ";
        };
   };
}