{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.lists) any;

  players = config.sylveon.programs.music-players;

  # get the source palette colors and use them here
  palette = 
    (lib.importJSON "${config.catppuccin.sources.palette}/palette.json")
      .${config.catppuccin.flavor}.colors;
in
{
  config = mkIf (any (x: x == "tidal") players) {
    # install music client
    sylveon.packages = { inherit (pkgs) sone; };

    # the settings.json is encrypted, meaning we can only 
    # set the theme.json
    # ---
    # write the theme into the config file
    xdg.configFile."sone/theme.json".text = builtins.toJSON {
      version = 1;
      preset = "custom";
      custom = {
        accent = palette.${osConfig.catppuccin.accent}.hex;
        background = palette.base.hex;
      };
    };
  };
}
