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
    cfg = config.${namespace}.common.secrets;
in
{
    options.${namespace}.common.secrets = {
        enable = mkEnableOption "Load all Age Keys; Deactivate if you have no SSH Keys...";

    };
  config = mkIf cfg.enable {
    # TODO: use "lib.snowfall.fs.get-file" if it works someday...
    age.secrets = {
        wifi-profiles.file =  ../../../../secrets/wifi-profiles.env.age;

        wg-vpn.file = ../../../../secrets/wg-vpn.key.age;
        wg-vpn-paired.file = ../../../../secrets/wg-vpn.paired-key.age;
    };
  };
}