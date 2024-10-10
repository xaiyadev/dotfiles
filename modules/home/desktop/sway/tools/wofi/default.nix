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
    cfg = config.${namespace}.desktop.config.sway.tools.wofi;
in
{
    options.${namespace}.desktop.config.sway.tools.wofi = {
        enable = mkEnableOption "Setup Wofi!";
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [ wofi-emoji ];

      programs.wofi = {
        enable = true;

        /* source: https://github.com/cement-drinker/wofi-rose-pine */
        style = ''
          window {
              margin: 0px;
              background-color: #191724;
              border-radius: 0px;
              border: 2px solid #ebbcba;
              color: #e0def4;
              font-family: 'Monofur Nerd Font';
              font-size: 15px;
          }

          #input {
              margin: 5px;
              border-radius: 0px;
              border: none;
              border-radius: 0px;
              color: #eb6f92;
              background-color: #26233a;

          }

          #inner-box {
              margin: 5px;
              border: none;
              background-color: #26233a;
              color: #191724;
              border-radius: 0px;
          }

          #outer-box {
              margin: 15px;
              border: none;
              background-color: #191724;
          }

          #scroll {
              margin: 0px;
              border: none;
          }

          #text {
              margin: 5px;
              border: none;
              color: #e0def4;
          }

          #entry:selected {
              background-color: #ebbcba;
              color: #191724;
              border-radius: 0px;
              outline: none;
          }

          #entry:selected * {
              background-color: #ebbcba;
              color: #191724;
              border-radius: 0px;
              outline: none;
          }
        '';
      };
    };
}