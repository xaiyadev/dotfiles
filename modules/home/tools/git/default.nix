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
    cfg = config.${namespace}.tools.git;
in
{
    options.${namespace}.tools.git = {
        enable = mkEnableOption "Install and configure git for all users";
        email = mkOption {
            type = types.str;
            default = "d.schumin@proton.me";
            example = "d.schumin@blmedia.de";
        };
    };

    config = mkIf cfg.enable {
       programs.git = {
         enable = true;
         package = pkgs.gitFull;
         userName = "Xaiya Schumin";
         userEmail = cfg.email;

         extraConfig = {
             commit.gpgsign = true;
             gpg.format = "ssh";
             user.signingkey = "~/.ssh/yubikey_xaiya";
         };
       };
    };
}
