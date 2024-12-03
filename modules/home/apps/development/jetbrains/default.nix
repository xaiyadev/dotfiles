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
    cfg = config.${namespace}.apps.development.jetbrains;
in
{
  options.${namespace}.apps.development.jetbrains = with types; {
    # The global enable just enables the compatiblity with the apricot git server (when done :/)
    enable = mkBoolOpt false "Wheter or not to enable some of the packages + enable sync with the git server";

    phpstorm = {
      enable = mkBoolOpt false "Whether or not to enable the PHPStorm IDE, for PHP and backend development";
      package = mkOpt package pkgs.jetbrains.phpstorm "The PHPStorm package";
    };

    webstorm = {
      enable = mkBoolOpt false "Wheter or not to enable the Webstorm IDE, for frontend and JS development";
      package = mkOpt package pkgs.jetbrains.webstorm "The Webstorm IDE package";
    };

    intellij = {
      enable = mkBoolOpt false "Whether or not to enable the Intellij IDE, for Java development";
      package = mkOpt package pkgs.jetbrains.idea-ultimate "The intellij IDE package";
    };
  };

  config = mkIf cfg.enable {

    home.packages = [
        (mkIf cfg.phpstorm.enable cfg.phpstorm.package)
        (mkIf cfg.webstorm.enable cfg.webstorm.package)
        (mkIf cfg.intellij.enable cfg.intellij.package)
    ];

    # This could go obselete if I completly switch to neovim
    # TODO: Add a git server for synchronization, and then use Jetbrains old git sync tool
    # TODO: Enable plugin and add configuration here
  };
}
