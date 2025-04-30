{osConfig, lib, self, ... }:
let
  inherit (self.lib.validation) isGraphical;
  inherit (lib) mkIf;

  theme = osConfig.sylveon.theme;
in
{
  config = mkIf (isGraphical osConfig) {
    stylix = {
      enable = true;

      image = "${self}/assets/wallpaper/mitaka.png";
      base16Scheme = theme.base16;
      polarity = "dark";
    };
  };
}