{ lib, osConfig, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf osConfig.sylveon.profiles.graphical.enable {
    # TODO: setup
    programs.mpv.enable = true;
  };
}