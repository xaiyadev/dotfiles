{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.sylveon.theme.fonts;
in
{
  options.sylveon.theme.fonts = {
    enable = mkEnableOption "configure fonts" // {
      default = osConfig.sylveon.profiles.graphical.enable;
    };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig = {
      defaultFonts = {
        monospace = [
          # default font I will go with
          "Maple Mono"

          # primary fallback
          "Source Code Pro"

          # unicode coverage
          "Noto Sans Mono"
          "Noto Sans"
          "Noto Serif"

          # icon fonts
          "Material Icons"
          "Material Design Icons"
        ];

        sansSerif = [
          "Maple Mono"

          # primary fallback
          "Source Sans 3"

          # Unicode coverage
          "Noto Sans"

          # icons
          "Material Icons"
          "Material Design Icons"
        ];

        serif = [
          "Maple Mono"

          # primary fallback
          "Source Serif 4"

          # unicode coverage
          "Noto Serif"

          # icons
          "Material Icons"
          "Material Design Icons"
        ];

        emoji = [
          "Twemoji Color Font"
        ];
      };
    };

    sylveon.packages = {
      inherit (pkgs.maple-mono) truetype;
    };
  };
}
