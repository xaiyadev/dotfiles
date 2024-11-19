{
  lib,
  pkgs,
  inputs,

  namespace,
  system,
  target,
  format,
  virtual,
  systems,

  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.hardware.yubikey;
in {

  options.${namespace}.hardware.yubikey = with types; {
    enable = mkBoolOpt false "Whether or not to enable the yubikey configuration and support";
    package = mkOpt (listOf package) [] "A list of udev packages that should be extra installed";
  };

  /*  Before Yubikey can complety work on the system, you need to manually configure some things.
   *  Look at the installation instructions in the README
   */
  config = mkIf cfg.enable {

    security.pam.yubico = {
      enable = true;

      mode = "challenge-response";
      id = [ "30683330" ];
    };

    # Enable Smartcard mode
    services.pcscd.enable = true;

    # Enable OTP checks and passkey listing
    environment.systemPackages = [ pkgs.yubioath-flutter ];

    # Install packages for udev
    services.udev.packages = [ pkgs.yubikey-personalization ] ++ cfg.package;

    # TODO: add udev event checks

    # TODO: add link to `/home/xayah/.yubico/` for challange response

  };
}
