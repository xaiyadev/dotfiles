{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  inherit (lib.types) bool;

  sway = osConfig.sylveon.graphical.sway;
in
{
  config = mkIf sway.enable {
    programs.kitty = {
      enable = true;

      shellIntegration.enableZshIntegration = config.programs.zsh.enable;
      enableGitIntegration = true;

      # removing annoying things
      settings.enable_audio_bell = false;
    };
  };
}