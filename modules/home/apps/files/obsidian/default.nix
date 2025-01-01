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
with lib.${namespace};
let
    cfg = config.${namespace}.apps.files.obsidian;
in
{
  options.${namespace}.apps.files.obsidian = with types; {
      enable = mkBoolOpt false "Whether or not to enable the MD file manager, obsidian";
  };

  /**
    * Obisidian is an MD file editor
    *
    * All settings and plugins are stored in the '.obsidian' folder in the vault
    * So no setting ups things here
   */
  config = mkIf cfg.enable {
    home.packages = [ pkgs.obsidian ];
  };
}
