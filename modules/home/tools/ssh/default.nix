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
    cfg = config.${namespace}.tools.ssh;
in
{

  /* Extra configuration for users after ssh is enabled */
  config = mkIf osConfig.${namespace}.system.ssh.enable {
    programs.ssh = {
      addKeysToAgent = "confirm";

      extraConfig = "HostkeyAlgorithms ssh-rsa";
      # Could need some fine tuning with ssh-add after first install
    };
  };
}
