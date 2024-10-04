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
    cfg = config.${namespace}.programs.minecraft;
in
{

    options.${namespace}.programs.minecraft = {
        enable = mkEnableOption "install minecraft and configure it";

        lunar-client = mkEnableOption "Enable Minecraft as Lunar Client";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [ lunar-client ];


    };
}