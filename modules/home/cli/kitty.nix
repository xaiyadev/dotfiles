{ config, self, pkgs, lib, ... }:
let
  inherit (lib) mkIf;

  inherit (self.lib.modules) mkPackageOpt;
  cfg = config.sylveon.cli.kitty;
in
{
  options.sylveon.cli.kitty =
    mkPackageOpt pkgs.kitty "Whether or not to install and configure kitty";

  config = {
    programs.kitty = {
      inherit (cfg) enable package;

      shellIntegration.enableZshIntegration = mkIf config.sylveon.cli.zsh.enable true;
      settings.enable_audio_bell = false;
    };
  };
}