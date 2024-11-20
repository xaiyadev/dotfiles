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
    cfg = config.${namespace}.common.yubikey;
in
{
    options.${namespace}.common.yubikey = {
        enable = mkEnableOption "Activate my yubikey security!";

    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ yubioath-flutter ];

      security.pam.services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };

      services.pcscd.enable = true;

      services.udev = {
        enable = true;
      #  extraRules = ''
      #  ACTION=="remove",\
      #   ENV{ID_BUS}=="usb",\
      #   ENV{ID_MODEL_ID}=="0407",\
      #   ENV{ID_VENDOR_ID}=="1050",\
      #   ENV{ID_VENDOR}=="Yubico",\
      #   RUN+="${pkgs.su}/bin/su $USER -c '${pkgs.swaylock-effects}/bin/swaylock'"
      #  '';
      };
    };
}
