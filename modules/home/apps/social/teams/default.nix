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
    cfg = config.${namespace}.apps.social.teams;
in
{
  options.${namespace}.apps.social.teams = with types; {
      enable = mkBoolOpt false "Whether or not Micorsoft teams should be installed for the user";
  };

  /**
    Microsoft Teams right now has no module and not many configuration options
    The settings are stored on the server of Mincrosoft (sadly)

    The Plugin tool is server-sided too, so now packages that need to be extra installed
   */
  config = mkIf cfg.enable { home.packages = [ pkgs.teams-for-linux ]; };
}
