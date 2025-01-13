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
    cfg = config.${namespace}.desktop.addons.swaylock;
in
{
    options.${namespace}.desktop.addons.swaylock = with types;with types;  {
        enable = mkEnableOption "Lock your screen in an cool way :3";
        package = mkOpt package pkgs.swaylock-effects "What swaylock package to use";
    };

    config = mkIf cfg.enable {
      programs.swaylock = {
        enable = true;
        package = cfg.package;

        settings = {
          font = "JetBrainsMono Nerd Font";

          /*
           *  Colors Scheme configuration
           *  Colors in this theme inspired from https://rosepinetheme.com/
           */
          color = "#1f1d2e";
          text-color = "#e0def4";


          inside-color = "#26233a";
          inside-caps-lock-color = "#26233a";
          inside-ver-color = "#26233a";
          inside-wrong-color = "#26233a";
          inside-clear-color = "#26233a";

          key-hl-color = "#9ccfd8";
          ring-color = "#403d52";
          ring-clear-color = "#eb6f92";
          ring-caps-lock-color = "#eb6f92";
          ring-ver-color = "#31748f";
          ring-wrong-color = "#eb6f92";


          /*
           *  Indicator Settings
           *  That thing that glows up in the circle, that is the indicator
           */
          indicator-radius = 100;
          indicator-thickness = 5;
          indicator = true;

          /*
           * Swaylock Effects Settings
           * If using the normal swaylock package, remove the code below
           */
          effect-blur = "7x5";
          effect-vignette = "0.8:0.8";

          grace = 2;

          screenshots = true;
          clock = true;

        };
      };
    };
}