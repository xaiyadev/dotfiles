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
    cfg = config.${namespace}.desktop.addons.gtk;
in
{
    options.${namespace}.desktop.addons.gtk = with types; {
        enable = mkBoolOpt false "Whether or not to enable the gtk configuration";

        theme = {
          name = mkOpt str "rose-pine-gtk" "What name the theme uses";
          package = mkOpt package pkgs.rose-pine-gtk-theme "What package the theme uses";
        };
    };

    config = mkIf cfg.enable {
      gtk = {
        enable = true;

        theme = {
          name = cfg.theme.name;
          package = cfg.theme.package;
        };
      };

      dconf = {
        enable = true;
        settings."org/gnome/desktop/interface".color-scheme = "prefer-dark"; # This seems like it only works for gnome, but this setting is completly for GTK 4
      };
    };
}
