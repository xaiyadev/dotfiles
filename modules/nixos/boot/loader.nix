{ lib, ... }:
let
  inherit (lib) mkForce;
in
{
  boot.loader = {
    timeout = mkForce 5; # Timeout after 5 seconds

    # allow installation to modify EFI variables
    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;
      configurationLimit = 3; # show the last 3 configurations
      consoleMode = "max"; # Pick the highest-numbered available mode

      # security hole,
      # for more see: https://mynixos.com/nixpkgs/option/boot.loader.systemd-boot.editor
      editor = false;
    };
  };
}
