{

  imports = [ ./hardware.nix ];

  config = {

    # TODO: Put into own module
    boot = {
      supportedFilesystems = [ "ntfs" ];

      loader = {
        efi.canTouchEfiVariables = true;

        grub = {
          enable = true;

          efiSupport = true;
          device = "nodev"; # grub will not be installed locally
          useOSProber = true;
        };
      };
    };

    system.stateVersion = "25.05";
  };
}