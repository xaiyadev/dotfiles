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
  cfg = config.${namespace}.hardware.bluetooth;
in {

  options.${namespace}.hardware.bluetooth = with types; {
    enable = mkBoolOpt false "Whether or not to bluetooth should be enabled by the pipewire deamon";
  };

  config = mkIf cfg.enable {

    # Enable bluez + Experimantal features
    hardware.bluetooth = {
      enable = true;
      settings.General.Experimental = true;
    };

    /* GUI tool for managing bluetooth devices */
    services.blueman = enabled;

    /*
     * Enable media-buttons for bluetooth devices
     * Visit: https://nixos.wiki/wiki/Bluetooth
     */
    systemd.user.services.mpris-proxy = {
        description = "Mpris proxy";
        after = [ "network.target" "sound.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy"; # bluez is installed by hardware.bluetoooth
    };

  };
}