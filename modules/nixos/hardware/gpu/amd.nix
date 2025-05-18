{ lib, self, config, ...}:
let
  inherit (lib) mkIf;

  gpu = config.sylveon.hardware.gpu;
in
{
  config = mkIf (gpu == "amd") {
    boot = {
      kernelParams = [
        # Fix Color accuracy in Power saving modes
        "amdgpu.abmlevel=0"
      ];

      kernelModules = [ "amdgpu" ];
      initrd.kernelModules = [ "amdgpu" ];
    };

    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}