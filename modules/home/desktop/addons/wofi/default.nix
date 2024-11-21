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
    cfg = config.${namespace}.desktop.addons.wofi;
in
{
    options.${namespace}.desktop.addons.wofi = with types; {
        enable = mkBoolOpt false "Whether or not the wofi menu should be installed";

        wofi-emoji.enable = mkBoolOpt true "Whether or not to enable the wofi-emoji package with my overlay";
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [ wofi-emoji ]; # Uses my overlay so it always uses the master branch for pulling emojis

      programs.wofi = {
        enable = true;

        /* source: https://github.com/cement-drinker/wofi-rose-pine */
        style = builtins.readFile ./style/index.css;
      };
    };
}