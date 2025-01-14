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
  cfg = config.${namespace}.security.yubikey;
in {

  options.${namespace}.security.yubikey = with types; {
    enable = mkBoolOpt false "Whether or not to enable the yubikey configuration and support";
    package = mkOpt (listOf package) [] "A list of udev packages that should be extra installed";
  };

  config = mkIf cfg.enable {

    /* Enable Passkey support */
    security.pam = {
      u2f = enabled;

      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };

    # Enable Smartcard mode
    services.pcscd.enable = true;

    # Enable OTP checks and passkey listing
    environment.systemPackages = [ pkgs.yubioath-flutter ];

    # Install packages for udev
    services.udev.packages = [ pkgs.yubikey-personalization ] ++ cfg.package;

    # TODO: add udev event checks (will be done after installing this system)
    # v5: Sway + Gnome
    # v4: Gnome
  };
}
