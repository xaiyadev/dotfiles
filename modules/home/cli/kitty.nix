{ config, self, pkgs, ... }:
let
  inherit (self.lib.modules) mkPackageOpt;
  cfg = config.sylveon.cli.kitty;
in
{
  options.sylveon.cli.kitty =
    mkPackageOpt pkgs.kitty "Whether or not to install and configure kitty";

  config = {
    programs.kitty = {
      inherit (cfg) enable package;

      shellIntegration.enableZshIntegration = true;
      settings.enable_audio_bell = false;
    };
  };
}