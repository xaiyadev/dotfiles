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
        "amdgpu.abmlevel=0" # Fix color accuracy in power saving mode
        "amdgpu.runpm=0" # disable dGPU runtime suspend (fix dGPU failing while system is running) # TODO: framework only?
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
