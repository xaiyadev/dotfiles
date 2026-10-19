{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  boot.loader = {
    timeout = mkForce 5; # Timeout after 5 seconds

    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;

      configurationLimit = 3;

      useOSProber = true;
      efiSupport = true;

      device = "nodev";
    };
  };
}
