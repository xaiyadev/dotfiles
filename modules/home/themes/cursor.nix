{ osConfig, self, ...}:
let
  inherit (self.lib.validation) isGraphical;

  theme = osConfig.sylveon.theme;
in
{

  config = {
    home.pointerCursor = {
      enable = (isGraphical osConfig) && !(isNull theme.cursor.package || isNull theme.cursor.name);
      package = theme.cursor.package;
      name = theme.cursor.name;
      size = 32;

      sway.enable = true;
      gtk.enable = true;
  };
  };
}