{
  config,
  osConfig,
  self,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.types) bool;
  inherit (self.lib.modules) mkOpt;

  sway = osConfig.sylveon.system.graphical.sway;
  cfg = config.sylveon.cli.kitty;
in
{
  options.sylveon.cli.kitty = {
    enable = mkOpt bool false "Enable cutest terminal like evveeerr !!";
  };

  config = mkIf (cfg.enable || sway.enable) {
    programs.kitty = {
      enable = true;

      shellIntegration.enableZshIntegration = config.programs.zsh.enable;
      enableGitIntegration = true;

      # removing annoying things
      settings.enable_audio_bell = false;
    };
  };
}
