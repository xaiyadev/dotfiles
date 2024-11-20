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
  cfg = config.${namespace}.hardware.audio;
in {

  options.${namespace}.hardware.audio = with types; {
    enable = mkBoolOpt false "Wheter or not to enable audio with the pipewire deamon";
    package = mkOpt (listOf package) [ ] "Audio managing packages; Defaults to pavucontrol";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ pavucontrol ] ++ cfg.package;

    security.rtkit.enable = true; # rtkit is optional but recommended

    /* Pipewire configuration; Does not need much configuration for my services */
    services.pipewire = {
      enable = true;

      # https://askubuntu.com/questions/581128/what-is-the-relation-between-alsa-and-pulseaudio-sound-architecture
      alsa = enabled;
      pulse = enabled;
      jack = enabled;
    };
  };
}
