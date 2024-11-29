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
    cfg = config.${namespace}.apps.development.phpstorm;
in
{
  options.${namespace}.apps.development.phpstorm = with types; {
      enable = mkBoolOpt false "Whether or not to enable the PHP IDE from jetbrains, phpstorm";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.jetbrains.phpstorm ];

    # This could go obselete if I completly switch to neovim
    # TODO: Add a git server for synchronization, and then use Jetbrains old git sync tool
    # TODO: Enable plugin and add configuration here
  };
}
