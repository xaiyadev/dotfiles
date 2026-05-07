{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkOption;
  inherit (lib.types) nullOr enum;

  inherit (config.sylveon.hardware) gpu;
in
{

  options.sylveon.hardware.gpu = mkOption {
    type = nullOr (enum [ "amd" ]);
    default = null;
    example = "amd";
    description = ''
      What GPU your system uses
    '';
  };

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

    # enables AMDVLK & OpenCL support
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = [
          pkgs.rocmPackages.clr
          pkgs.rocmPackages.clr.icd
        ];
      };
    };

    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
