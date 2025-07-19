{ config, self, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (self.lib.modules) mkPackageOpt;

  zsh = config.sylveon.cli.zsh;
  cfg = config.sylveon.cli.direnv;
in
{

  options.sylveon.cli.direnv =
    mkPackageOpt pkgs.direnv "Whether or not to enable direnv support";

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      inherit (cfg) package;

      enableZshIntegration = zsh.enable;
      nix-direnv.enable = true;
    };

    # Enable starship configuration for direnv
    programs.starship.settings.direnv.disabled = true;
  };
}