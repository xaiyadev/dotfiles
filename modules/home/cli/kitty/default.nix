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
    cfg = config.${namespace}.cli.kitty;
in
{
  options.${namespace}.cli.kitty = with types; {
      enable = mkBoolOpt false "Whether or not to enable the Kitty terminal";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;

      themeFile = "rose-pine";
      font = {
        name = "Jetbrains Mono";
        package = pkgs.jetbrains-mono;
        size = 12;
      };

      settings = {
        enable_audio_bell = false;
        
        dynamic_background_opacity = true;
        background_opacity = 0.9;
        background_blur = 1;
      };
    };

  };
}
