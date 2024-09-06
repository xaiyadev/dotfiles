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
    cfg = config.${namespace}.programs.vesktop;

in
{
    options.${namespace}.programs.vesktop = {
        enable = mkEnableOption "Install and setup vesktop";
    };

    config = mkIf cfg.enable {
         home.file.".config/vesktop/themes/mocha.theme.css".source = ./themes/mocha.theme.css;

        home.packages = with pkgs; [
            vesktop
        ];
    };
}