# ADDING THIS ONLY BECAUSE OF SCHOOL :(
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
    cfg = config.${namespace}.programs.vscode;
in
{
    options.${namespace}.programs.vscode = {
        enable = mkEnableOption "Install and setup vscode";
    };

    config = mkIf cfg.enable {
        programs.vscode = {
          enable = true;
        };
    };
}