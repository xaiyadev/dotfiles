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
    cfg = config.${namespace}.services.minecraft.survival;
    minecraft-cfg = config.${namespace}.services.minecraft;
in
{
    options.${namespace}.services.minecraft.survival = {
        enable = mkEnableOption "Setup of the Minecraft Servers";
    };

    config = mkIf cfg.enable {
        services.minecraft-servers.servers.survival = {
          enable = true;
          package = pkgs.paperServers.paper-1_21_1;

          autoStart = true;
          enableReload = true;

          serverProperties = {
            server-port = 25565;
            motd = ''Survival Minecraft Server hosted on NIX!'';
            difficulty = "hard";
          };


        };
    };
}
