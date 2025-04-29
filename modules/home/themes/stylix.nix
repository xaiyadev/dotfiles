{osConfig, self, ... }:
let
  theme = osConfig.sylveon.theme;
in
{
  config = {
    stylix = {
      enable = true;

      image = "${self}/assets/mitaka.png";
      base16Scheme = theme.base16;
      polarity = "dark";
    };
  };
}