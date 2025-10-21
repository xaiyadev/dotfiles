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
  inherit (self.lib.modules) mkPackageOpt;

  sway = osConfig.sylveon.system.graphical.sway;
  cfg = config.sylveon.cli.kitty;
in
{
  options.sylveon.cli.kitty = mkPackageOpt pkgs.kitty "Whether or not to install and configure kitty";

  config = mkIf (cfg.enable || sway.enable) {
    programs.kitty = {
      enable = true;
      inherit (cfg) package;

      shellIntegration.enableZshIntegration = config.programs.zsh.enable;
      enableGitIntegration = true;
      themeFile = "rose-pine";

      # removing annoying things
      settings.enable_audio_bell = false;
    };

    stylix.targets.kitty.enable = false; # Using the kitty theme instead of base16
  };
}
