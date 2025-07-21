{
  config,
  self,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (self.lib.modules) mkPackageOpt;

  zsh = config.sylveon.cli.zsh;
  cfg = config.sylveon.cli.kitty;
in
{
  options.sylveon.cli.kitty = mkPackageOpt pkgs.kitty "Whether or not to install and configure kitty";

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      inherit (cfg) package;

      shellIntegration.enableZshIntegration = zsh.enable;
      settings.enable_audio_bell = false;
    };
  };
}
