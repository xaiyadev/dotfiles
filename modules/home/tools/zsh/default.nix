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
    cfg = config.${namespace}.tools.zsh;
in
{
    options.${namespace}.tools.zsh = {
        enable = mkEnableOption "Install and enable zsh";
    };

    config = mkIf cfg.enable {
      programs.zsh = {
        enable = true;

        history.path = "${config.home.homeDirectory}/.local/share/zsh/.zsh_history";

        plugins = [
          {
            name = "zsh-completions";
            src = pkgs.zsh-completions;
          }
          {
            name = "zsh-syntax-highlighting";
            file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
            src = pkgs.zsh-syntax-highlighting;
          }
          {
            name = "zsh-nix-shell";
            file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
            src = pkgs.zsh-nix-shell;
          }
        ];
      };
    };
}