{
  lib,
  self,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  cpu = config.sylveon.device.cpu;
in
{
  config = mkIf (cpu == "amd") {
    hardware.cpu.amd.updateMicrocode = true;

    boot.kernelModules = [
      "kvm-amd"
      "amd-pstate"
    ];
  };
}
