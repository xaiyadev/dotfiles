{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.sylveon.programs.keepassxc;
in
{

  options.sylveon.programs.keepassxc.enable =
    mkEnableOption "Whether or not to install";

  config = mkIf cfg.enable {
    programs.keepassxc.enable = true;
  };
}
