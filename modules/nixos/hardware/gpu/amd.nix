{ lib, self, pkgs, config, ...}:
let
  inherit (lib) mkIf;

  gpu = config.sylveon.device.gpu;
in
{
  config = mkIf (gpu == "amd") {
    boot = {
      kernelModules = [ "amdgpu" ];
      initrd.kernelModules = [ "amdgpu" ];
    };

    # enables AMDVLK & OpenCL support
    hardware.graphics.extraPackages = [
      pkgs.rocmPackages.clr
      pkgs.rocmPackages.clr.icd
    ];

    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}