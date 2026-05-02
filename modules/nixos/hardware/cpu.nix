{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkMerge;

  cpu = config.sylveon.device.cpu;
in
{
  options.sylveon.device.cpu = mkOpt (enum [
    "amd"
    "intel"
  ]) null "What cpu your system uses";

  config = mkMerge [
    (mkIf (cpu == "amd") {
      hardware.cpu.amd.updateMicrocode = true;

      boot.kernelModules = [
        "kvm-amd"
        "amd-pstate"
      ];
    })

    (mkIf (cpu == "intel") {
        hardware.cpu.intel.updateMicrocode = true;

        boot = {
          kernelModules = [ "kvm-intel" ];
          kernelParams = [
            "i915.fastboot=1"
            "enable_gvt=1"
          ];
        };
    })
  ];
}