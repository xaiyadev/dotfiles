{ lib, self, config, ...}:
let
  inherit (lib) mkIf;

  cpu = config.sylveon.hardware.cpu;
in
{
  config = mkIf (cpu == "amd") {
    hardware.cpu.amd.updateMicrocode = true;

    boot = {
      kernelModules = [
        "kvm-amd"
        "amd-pstate"
      ];

      kernelParams = [
        # Fix Color accuracy in Power saving modes
        "amdgpu.abmlevel=0"
      ];
    };
  };
}