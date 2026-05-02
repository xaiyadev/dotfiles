{
  pkgs,
  self,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
in
{

  options.sylveon.hardware.yubikey.enable =
    mkEnableOption "yubikey";

  config = {
      hardware.gpgSmartcards.enable = true;

      services = {
        pcscd.enable = true;
        udev.packages = [ pkgs.yubikey-personalization ];
      };

      # Add yubico's official tools
      sylveon.packages = {
        inherit (pkgs) yubikey-manager yubioath-flutter;
      };

      # security.pam.services.swaylock.text = "auth include login"; TODO
  };
}