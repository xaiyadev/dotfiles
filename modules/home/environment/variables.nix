{ config, osConfig, ... }:
let
  inherit (config.sylveon.programs) defaults;
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
    GIT_DIR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    PAGER = "less -FR";
    MANPAGER = "nvim +Man!";
  };
}