{
  config,
  lib,
  self,
  pkgs,
  inputs,
  osConfig,
  ...
}:
let

  inherit (lib)
    mkIf
    mkMerge
    ;

  inherit (lib.types) bool package;
  inherit (self.lib.modules) mkOpt;

  cfg = config.sylveon.programs.jetbrains;
in
{

  options.sylveon.programs.jetbrains = {
    phpstorm = {
      enable = mkOpt bool false "Whether or not to enable the jetbrains php-editor";
      package = mkOpt package pkgs.jetbrains.phpstorm "What package to use for the jetbrains php-editor";
    };

    webstorm = {
      enable = mkOpt bool false "Whether or not to enable the jetbrains web-editor";
      package = mkOpt package pkgs.jetbrains.webstorm "What package to use for the jetbrains web-editor";
    };
  };

  config = mkIf (cfg.phpstorm.enable || cfg.webstorm.enable) {
    home.file.".ideavimrc".source = ./.ideavimrc;

    home.packages =
    let
      defaultPlugins = with pkgs.jetbrains-plugins; [
        com.github.catppuccin.jetbrains
        com.mallowigi # Atom material icons

        io.github.pandier.intellijdiscordrp
        # com.wakatime.intellij.plugin TODO

        IdeaVIM

        nix-idea
        com.jetbrains.plugins.ini4idea
      ];
    in
      lib.optionals cfg.phpstorm.enable [
        (pkgs.jetbrains-plugins.lib.buildIdeWithPlugins
          cfg.phpstorm.package
          (with pkgs.jetbrains-plugins; [
            # adrienbrault.idea.symfony2plugin
          ] ++ defaultPlugins)
        )
      ]

      ++ lib.optionals cfg.webstorm.enable [
        (pkgs.jetbrains-plugins.lib.buildIdeWithPlugins
          cfg.webstorm.package
          defaultPlugins
        )
      ];
  };
}
