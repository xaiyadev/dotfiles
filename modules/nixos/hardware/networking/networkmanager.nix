{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf;

  prof = config.sylveon.profiles;
in
{
  sylveon.packages = {
    inherit (pkgs) networkmanagerapplet; # GUI tool for networking
  };

  network.networkmanager = {
    enable = true;
    dns = "systemd-resolved";

    wifi = mkIf prof.laptop.enable {
      backend = "iwd";
      powersave = true;

      scanRandMacAddress = true;
    };
  };
}