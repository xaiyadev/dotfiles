{
  pkgs,
  ...
}:
let

  inherit (builtins)
    fetchurl
    readFile
    fromTOML
    ;
in
{
  home.shell.enableZshIntegration = true;

  programs.zsh = {
    enable = true;

    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

  };
}
