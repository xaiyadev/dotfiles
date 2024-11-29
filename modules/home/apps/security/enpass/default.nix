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

  osConfig,
  config,
  specialArgs,
  ...
}:
with lib;
with lib.${namespace};
let
    cfg = config.${namespace}.apps.security.enpass;
in
{
  options.${namespace}.apps.security.enpass = with types; {
      enable = mkBoolOpt false "Wheter or not to enable the Password Manager 'Enpass'";
  };

  /**
    * Enable the Enpass Desktop App
   */
  config = mkIf cfg.enable {
    home.packages = [ pkgs.enpass ];


    # Add Enpass to the automatic startup
    wayland.windowManager.sway.config.startup = mkIf osConfig.${namespace}.desktop.sway.enable [
      # Startup Enpass, then enter enpass request for your passowrd
      { command = ''exec Enpass''; }
    ];
  };
}
