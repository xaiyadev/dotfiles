{ config, self, lib, pkgs, ... }:
let
  inherit (lib.types) bool;
  inherit (lib) mkIf;

  inherit (self.lib.modules) mkOpt;
  cfg = config.sylveon.hardware.bluetooth;
  prof = config.sylveon.profiles;
in
{
  options.sylveon.hardware.bluetooth.enable = mkOpt
    bool
    prof.laptop.enable
    "Whether or not bluetooth should be enabled or not";

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez;
      powerOnBoot = true;

      settings = {
        General = {
          MultiProfile = "multiple";
          Experimental = true;
        };
      };
    };

    services.blueman.enable = true;
  };
}