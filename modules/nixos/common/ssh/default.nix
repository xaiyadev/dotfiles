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
    cfg = config.${namespace}.common.ssh;
in
{
    options.${namespace}.common.ssh = {
        enable = mkEnableOption "Setup all SSH settings and keys!";


    };

    config = mkIf cfg.enable {
      programs.ssh.startAgent = true;
      services.openssh = {
        enable = true;
        knownHosts = {
          "192.168.1.126".publicKeyFile = ./pubFiles/apricot_ssh_host.pub;
          "github.com".publicKeyFile = ./pubFiles/github_ssh_host.pub;
        };
      };
    };
}