{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;

  cpu = config.sylveon.device.cpu;
in
{
  options.sylveon.device.gpu = mkOpt (enum [
    "amd"
  ]) null "What gpu your system uses";

  config = mkIf (cpu == "amd") {
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
