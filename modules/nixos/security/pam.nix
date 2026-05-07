{ lib, config, ... }:
let
  inherit (lib) mkIf;
in
{
  # Allow swaylock to also unlock the screen
  security.pam = {
    u2f = mkIf config.sylveon.hardware.yubikey.enable {
      enable = true;
      settings.cue = true;
    };

    services.swaylock.text = "auth include login";
  };
}
