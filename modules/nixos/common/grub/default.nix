{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  config,
  specialArgs,
  ...
}:
with lib;
let
   cfg = config.${namespace}.common.grub;
in {

   options.${namespace}.common.grub = {
     enable = mkEnableOption "Activate Grub Boot Loader!";

     windowsSupport = mkOption {
       type = types.bool;
       default = false;
       example = true;
       description = "If ntfs File systems and boots should be supported";
     };

     device = mkOption {
       type = types.str;
       default = "nodev";
       example = "/dev/sda";
       description = "The device grub should be installed on; If 'nodev' grub will not be installed localy!";
     };
   };

    config = mkIf cfg.enable {
        boot.supportedFilesystems = if cfg.windowsSupport then [ "ntfs" ] else [ ];
        boot.loader = {
        efi.canTouchEfiVariables = true;

        # TODO: fix windows not found
        grub = {
          enable = true;
          device = cfg.device;
	        efiSupport = true;

	        useOSProber = cfg.windowsSupport;

          catppuccin = {
            enable = true;
            flavor = specialArgs.cattpuccin.flavor;
          };
        };
      };
  };
}
