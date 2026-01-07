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

  inherit (lib.types) bool;
  inherit (self.lib.modules) mkOpt;

  cfg = config.sylveon.programs.jetbrains;
in
{

  options.sylveon.programs.jetbrains = {
    phpstorm.enable = mkOpt bool false "Enable the PHP-Editor for jetbrains";
    webstorm.enable = mkOpt bool false "Enable the Web-Editor for jetbrains";
  };

  config = {
    home.packages =
      let
        defaultPlugins =
          [

          ]
          ;

        loadIde =
          ide: plugins:
          pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains."${ide}" defaultPlugins ++ (
            builtins.map (p: TODO."${ide}"."${pkgs.jetbrains."${ide}".version}"."${p}") plugins
          )
          ;

      in
      lib.optionals cfg.phpstorm.enable [
        (inputs.nix-jetbrains-plugins.lib."${system}".buildIdeWithPlugins pkgs.jetbrains "webstorm" defaultPlugins ++ [
        ])
      ]
      ++ lib.optionals cfg.webstorm.enable [
        (pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.webstorm defaultPlugins ++ (
          builtins.map (p: plugins.webstorm."${pkgs.jetbrains.webstorm.version}"."${p}") [
            ""
          ]
        ))
      ];
  };
}
