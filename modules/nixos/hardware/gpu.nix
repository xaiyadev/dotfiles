{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkOption;
  inherit (lib.types) enum;

  cpu = config.sylveon.hardware.cpu;
in
{

  options.sylveon.system.gpu = mkOption {
      type = enum [ "amd" ];
      default = null;
      example = "amd";
      description = ''
        What GPU your system uses
      '';
    };

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
