{ osConfig, lib, config, ... }:
let
  inherit (lib) mkIf fileContents mkEnableOption;
in
{

  options.sylveon.programs.neovim.enable = mkEnableOption "Neovim with configuration";

  config = mkIf config.sylveon.programs.neovim.enable {
    xdg.configFile."nvim".source = ./config;

    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;

      withRuby = false;
      withPython3 = false;

      plugins = [ ];
    };
  };
}
