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
    cfg = config.${namespace}.apps.games.steam;
in
{
  options.${namespace}.apps.games.steam = with types; { enable = mkBoolOpt false "Whether or not enable the Steam Client"; };

  /**
   * Game Manager, Launcher and Store!
   * TODO: Add a script to autmaticly install a list of games (array with game IDs)
   */
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.steam

      # Steam Terminal utilities
      pkgs.steam-tui
      pkgs.steamcmd # SteamCMD needs to configure login before you can use steam-tui
    ];
  };
}
