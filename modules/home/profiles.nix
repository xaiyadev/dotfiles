{ lib, osConfig, ... }:
let
  inherit (lib) mkEnableOption;
in
{
  options.sylveon.profiles.user = {
    gaming.enable = mkEnableOption "configure user to use gaming modules";
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
