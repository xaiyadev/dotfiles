{osConfig, inputs,  ... }:
let
  theme = osConfig.sylveon.theme;
in
{
  imports = [ inputs.homeManagerModules.stylix ];
  config = {
    stylix = {
      enable = true;
      base16Scheme = theme.base16;
      polarity = "dark";
    };
  };
}