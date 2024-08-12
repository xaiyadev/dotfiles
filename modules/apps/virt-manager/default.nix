{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.virt-manager;
in
{
    options.services.virt-manager = {
        enable = mkEnableOption "custom virt-manager service";
    };

    config = mkIf cfg.enable {
        # Needs to be configured in local machine
        # virtualisation.libvirtd.enable = true;

        home.packages = with pkgs; [ virt-manager ];

        dconf.settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = ["qemu:///system"];
            uris = ["qemu:///system"];
          };
        };


    };
}