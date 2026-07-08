{ config, lib, pkgs, ... }:
let
  inherit (config.sylveon.hardware) gpu;
  inherit (lib) mkIf;
in
{
  config = mkIf (gpu == "amd") {
    boot = {
      kernelModules = [ "amdgpu" ];
      initrd.kernelModules = [ "amdgpu" ];

      kernelParams = [
        # Fix color accuracy in power saving mode
        "amdpgu.admblevel=0"
        "acpi_backlight=native"
      ];
    };

    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
