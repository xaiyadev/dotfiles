{osConfig, inputs, self, ... }:
let
  theme = osConfig.sylveon.theme;
in
{
  config = {
    stylix = {
      enable = true;
      base16Scheme = theme.base16;
      polarity = "dark";
    };
  };
}