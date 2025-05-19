{osConfig, lib, self, inputs, ... }:
let
  inherit (lib) mkIf;

  inherit (self.lib.validation) isGraphical;
  theme = osConfig.sylveon.theme;
in
{
  imports = [ inputs.stylix.homeModules.stylix ];

  config = mkIf (isGraphical osConfig) {
    stylix = {
      enable = true;
      enableReleaseChecks = false; # Stylix is sometimes behind home-manager, nothing we can do

      image = "${self}/assets/wallpaper/Mizuki_34_trained_art.png";
      base16Scheme = theme.base16;
      polarity = "dark";
    };
  };
}