{
  lib,
  config,
  self,
  ...
}:
let
  inherit (lib)
    mkIf
    mkMerge
    ;

  inherit (lib.types) str enum;

  inherit (self.lib.modules) mkOpt;
  cfg = config.sylveon.system.boot;
in
{

  options.sylveon.system.boot = {
    loader = mkOpt (enum [
      "grub"
      "systemd-boot"
    ]) "systemd-boot" "What boot loader should be used";

    grub = {
      device = mkOpt str "nodev" "The device that the bootloader should be installed on.";
    };
  };

  config = mkMerge [
    (mkIf (cfg.loader == "systemd-boot") {
      boot.loader.systemd-boot = {
        enable = true;
        configurationLimit = 3; # just show the last 3 configurations that can be loaded
        consoleMode = "max";

        # security hole, for more see: https://mynixos.com/nixpkgs/option/boot.loader.systemd-boot.editor
        editor = false;
      };
    })

    (mkIf (cfg.loader == "grub") {
      boot.loader.grub = {
        enable = true;
        inherit (cfg.grub) device;

        efiSupport = true;
        useOSProber = true;
      };
    })
  ];
}
