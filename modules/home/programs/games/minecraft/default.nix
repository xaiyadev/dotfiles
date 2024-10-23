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
    cfg = config.${namespace}.programs.games.minecraft;

    resourcepacks = ./resourcepacks;
    shaderpacks = ./shaderpacks;
    mods = ./mods;
in
{
    # TODO: will be replaced in: https://github.com/BreakingTV/nur-packages
    options.${namespace}.programs.games.minecraft = {
      enable = mkEnableOption "install minecraft and configure it";
      package = mkOption {
        type = types.package;
        default = pkgs.minecraft;
        description = ''
          What minecraft launcher should be used.
        '';
      };

      resourcepacks.install = mkEnableOption "If the resourcepacks should be installed";
      shaderpacks.install = mkEnableOption "If the shaderpacks should be installed";
      mods.install = mkEnableOption "If the mods should be installed";
    };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [ cfg.package ];

        /* The following scripts will only run if you update the home-manager config! */

        /*
         * I use lunar-client, which allows you to store resourcepacks in subdirectorys
         * Please only do this if you have a client that supports subdirectorys!
         */
        home.activation.minecraft-installResourcepacks = mkIf cfg.resourcepacks.install ''
          mkdir -p ${config.home.homeDirectory}/.minecraft/resourcepacks/nixos-generated &&
          chmod 777 -R ${config.home.homeDirectory}/.minecraft/resourcepacks &&
          cp -ar ${resourcepacks}/* ${config.home.homeDirectory}/.minecraft/resourcepacks/nixos-generated
        '';

        home.activation.minecraft-installShaderpacks = mkIf cfg.shaderpacks.install ''
          mkdir -p ${config.home.homeDirectory}/.minecraft/shaderpacks &&
          chmod 777 -R ${config.home.homeDirectory}/.minecraft/shaderpacks &&
          cp -ar ${shaderpacks}/* ${config.home.homeDirectory}/.minecraft/shaderpacks
        '';

        /* Some mods could be very large, be carefull! */
        home.activation.minecraft-installMods = mkIf cfg.mods.install ''
          mkdir -p ${config.home.homeDirectory}/.minecraft/mods &&
          chmod 777 -R  ${config.home.homeDirectory}/.minecraft/mods &&
          cp -ar ${mods}/* ${config.home.homeDirectory}/.minecraft/mods
        '';


    };
}