{
  lib,
  pkgs,
  inputs,

  namespace,
  system,
  target,
  format,
  virtual,
  systems,

  config,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.system.fonts;
in {

  options.${namespace}.system.fonts = with types; {
    enable = mkBoolOpt false "Wheter or not to install all necessary fonts";
    fonts = mkOpt (listOf package) [] "Custom fonts to install";
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      /* default fonts */
      jetbrains-mono

      /* icons and other utilities */
      font-awesome
      material-design-icons
      pkgs.nerd-fonts.jetbrains-mono
    ]
    ++ cfg.fonts;

    # Enable icons in tooling since we have nerdfonts
    environment.variables.LOG_ICONS = "true";
  };
}
