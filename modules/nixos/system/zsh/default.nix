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
  cfg = config.${namespace}.system.zsh;
in {

  options.${namespace}.system.zsh = with types; {
    enable = mkBoolOpt false "Whether or not to enable the zsh shell";
  };

  /*
  * This module is only for activating the shell and putting it as the defaultUserShell
  * The configuration will be automatically activated in the home module
  */
  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;
  };
}

