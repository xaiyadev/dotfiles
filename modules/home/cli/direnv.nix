{ config, self, lib, pkgs, ... }:
let
  inherit (lib) mkIf;

  inherit (self.lib.modules) mkPackageOpt;
  cfg = config.sylveon.cli.direnv;
in
{

  options.sylveon.cli.direnv =
    mkPackageOpt pkgs.direnv "Whether or not to enable direnv support";

  config = {
    programs.direnv = {
      inherit (cfg) enable package;

      enableZshIntegration = mkIf config.sylveon.cli.zsh.enable true;
      nix-direnv.enable = true;
    };

    # Enable starship configuration for direnv
    programs.starship.settings.direnv.disabled = cfg.enable;
  };
}