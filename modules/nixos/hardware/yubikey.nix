{ pkgs, self, lib, config, ... }:
let
  inherit (self.lib.modules) mkOpt;
  inherit (lib.types) bool;
  inherit (lib) mkIf;

  cfg = config.sylveon.hardware.yubikey;
in
{


  options.sylveon.hardware.yubikey.enable =
    mkOpt bool true "Whether or not yubikey support should be enabled";

  config = mkIf cfg.enable {
    # Enables support for login and authentication with the yubikey
    security.pam.u2f = {
      enable = true;
      # settings.authFile = TODO: add one file location for all users
    };


    hardware.gpgSmartcards.enable = true;

    services = {
      pcscd.enable = true;
      udev.packages = [ pkgs.yubikey-personalization ];
    };

     # use gnupg agent as main agent
     programs = {
       ssh.startAgent = false;

       gnupg.agent = {
         enable = true;
         enableSSHSupport = true;
         # enableBrowserSocket = true; TODO: do that?
       };
    };

    # Add yubico's official tools
    environment.systemPackages = [
      pkgs.yubikey-manager # cli
      pkgs.yubioath-flutter # gui
    ];
  };
}