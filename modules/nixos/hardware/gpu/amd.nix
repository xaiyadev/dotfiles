{ config, lib, ... }:
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

    nixpkgs.config.rocmSupport = true;
    hardware.amdgpu.opencl.enable = true;

    services.xserver.videoDrivers = [ "amdgpu" ];

    # tool for overclocking and managing amd gpus
    services.lact.enable = true;
  };
}
