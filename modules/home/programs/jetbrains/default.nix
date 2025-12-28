{
  config,
  lib,
  self,
  pkgs,
  inputs',
  osConfig,
  ...
}:
let

  inherit (lib)
    mkIf
    mkMerge
    ;

  inherit (lib.types) bool;

  inherit (self.lib.modules) mkOpt;

  cfg = config.sylveon.programs.jetbrains;
in
{

  options.sylveon.programs.jetbrains = {
    phpstorm.enable = mkOpt bool false "Enable the PHP Editor for jetbrains";
    webstorm.enable = mkOpt bool false "Enable the Web-Editor for jetbrains";
  };

  config = mkMerge [

    # Default configuration
    ((mkIf builtins.any (x: x.enable) cfg) { 
      # VIM configuration

      # plugins installation ++ configuration
      # plugin list: IDEAVim; Rainbowbrackets; Atom Material Icons ++ Theme; NixIdea

      # Settings configuration
        # Theme configuration

      # Keybindings
    })

    # Install packages
    {
      home.packages = [ # TODO: move to own parts if bigger separating configs?
        (mkIf cfg.phpstorm.enable pkgs.jetbrains.phpstorm)
        (mkIf cfg.webstorm.enable pkgs.webstorm.phpstorm)
      ];
    }

  ];
}
