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
    cfg = config.${namespace}.tools.git;
in
{
  options.${namespace}.tools.git = with types; {
      enable = mkBoolOpt false "Whether or not to enable git for your system";
      extraPackages = mkOpt (listOf package) [ ] "What extra packages should be installed. Can be GUI apps for git or other stuff";

      ssh-key = mkOpt str "~/.ssh/id_ed25519_sk" "Where the ssh key for authentication is located"; # id_ed25519_sk is my yubikey
      user = {
        name = mkOpt str "Xaiya Schumin" "Which name you want to use when using git";
        email = mkOpt str "d.schumin@proton.me" "What email git should use";
      };
  };

  config = mkIf cfg.enable {
    home.packages = cfg.extraPackages;

    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      userName = cfg.user.name;
      userEmail = cfg.user.email;

      extraConfig = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = cfg.ssh-key;
      };
    };
  };
}
