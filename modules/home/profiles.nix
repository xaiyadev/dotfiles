{ lib, osConfig, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.sylveon.profiles.user = {
    gaming.enable = mkEnableOption "configure user to use gaming modules";
    music.enable = mkEnableOption "If this profile should have support for music streaming services; scrobbeling; etc.";
  };

  config = {
    sylveon.profiles = {
      inherit (osConfig.sylveon.profiles)
        graphical
        laptop
        server
        ;
    };
  };
}
