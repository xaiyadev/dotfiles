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
    cfg = config.${namespace}.apps.zen;
in
{
  options.${namespace}.apps.zen = with types; {
      enable = mkBoolOpt false "Whether or not to enable the Zen Browser and configurate it";
  };

  /**
    The Zen-Browser is still in development
    there is no module to configure it, and it has still some flaws

    Until the zen-browser is officialy in NixOS and there is a module option, I will continue to use chromium
    For more information follow: https://github.com/NixOS/nixpkgs/issues/327982
   */
  config = mkIf cfg.enable {
    home.packages = [ inputs.zen-browser.packages."${system}".default ]; # Installs the Zen-Browser from my flakes
  };
}
