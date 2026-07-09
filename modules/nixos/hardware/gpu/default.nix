{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption;
  inherit (lib.types) nullOr enum;
in
{

  imports = [
    ./amd.nix
    ./nvidia.nix
  ];

  options.sylveon.hardware.gpu = mkOption {
    type = nullOr (enum [
      "amd"
      "nvidia"
    ]);
    default = null;
    example = "amd";
    description = ''
      What GPU your system uses
    '';
  };

  config = {
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
  };
}
