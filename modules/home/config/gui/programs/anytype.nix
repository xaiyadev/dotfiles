{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.sylveon.programs.anytype;
in
{

  options.sylveon.programs.anytype.enable = mkEnableOption "Enable note database 'anytype'";

  config = mkIf cfg.enable {
    sylveon.packages = {
      inherit (pkgs) anytype;
    };
  };
}
