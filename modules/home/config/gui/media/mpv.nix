{ lib, config, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.sylveon.profiles.graphical.enable {
    # TODO: setup
    programs.mpv.enable = true;
  };
}
