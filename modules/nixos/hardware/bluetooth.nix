{

  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.sylveon.hardware.bluetooth;
  prof = config.sylveon.profiles;
in
{

  options.sylveon.hardware.bluetooth.enable =
    mkEnableOption "Whether or not bluetooth should be enabled or not"
    // {
      default = prof.laptop.enable;
    };

  config = mkIf cfg.enable {
    # TODO: controller not working?
    sylveon.packages = {
      inherit (pkgs) overskride;
    };

    boot.kernelModules = [ "btusb" ];

    hardware.bluetooth = {
      enable = true;

      settings = {
        General = {
          Experimental = true;
        };
      };
    };
  };

}
