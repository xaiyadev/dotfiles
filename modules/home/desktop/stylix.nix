{ osConfig, lib, self, inputs, ... }:
let
  inherit (lib) mkIf;

  prof = osConfig.sylveon.profiles;
  theme = osConfig.sylveon.system.theme;
in
{
  imports = [ inputs.stylix.homeModules.stylix ];

  config = mkIf prof.graphical.enable {
    stylix = {
      enable = true;
      enableReleaseChecks = false; # Stylix is sometimes behind home-manager, nothing we can do

      image = "${self}/assets/wallpaper/Mizuki_34_trained_art.png";
      base16Scheme = theme.base16;
      polarity = "dark";
    };
  };
}