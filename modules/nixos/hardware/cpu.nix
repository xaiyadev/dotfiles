{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkMerge mkOption;
  inherit (lib) enum;

  cpu = config.sylveon.hardware.cpu;
in
{

  options.sylveon.hardware.cpu = mkOption {
      type = enum [ "amd" "intel" ];
      default = null;
      example = "amd";
      description = ''
        What CPU your system uses
      '';
    };


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