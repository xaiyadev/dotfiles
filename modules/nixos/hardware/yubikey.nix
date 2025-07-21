{ pkgs, self, lib, config, ... }:
let
  inherit (self.lib.modules)
    mkOpt
    ;

  inherit (lib.types)
    bool
    ;

  inherit (lib)
    mkIf
    mkMerge
    ;

  cfg = config.sylveon.hardware.yubikey;
  prof = config.sylveon.profiles;
in
{

  options.sylveon.hardware.yubikey.enable =
    mkOpt bool true "Whether or not yubikey support should be enabled";

  config = mkMerge [
    (mkIf cfg.enable {
      hardware.gpgSmartcards.enable = true;

      # Enables support for login and authentication with the yubikey
      security.pam.u2f = {
        enable = true;
        settings.cue = true;
      };

      services = {
        pcscd.enable = true;
        udev.packages = [ pkgs.yubikey-personalization ];
      };

       # use gpg agent instead of the ssh agent
       programs = {
         ssh.startAgent = false;

         gnupg.agent = {
           enable = true;
           enableSSHSupport = true;
           enableBrowserSocket = true;
         };
      };

      # Add yubico's official tools
      environment.systemPackages = [ pkgs.yubikey-manager ]; # cli
    })

    (mkIf (cfg.enable && prof.graphical.enable) {
      security.pam.services.swaylock.text = "auth include login";
      environment.systemPackages = [ pkgs.yubioath-flutter ]; # gui
    })
  ];
}