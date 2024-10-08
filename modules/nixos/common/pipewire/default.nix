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
    cfg = config.${namespace}.common.pipewire;
in
{
    options.${namespace}.common.pipewire = {
        enable = mkEnableOption "makes: Audio; Microphone; Streaming; etc. working";

    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ pavucontrol ];


      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    };
}
