{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf mkMerge;

  prof = config.sylveon.profiles;
in
{
  programs = mkMerge [
    (mkIf prof.graphical.enable {
      dconf.enable = true;
      seahorse.enable = true;
    })

    {
      # I only use zsh as a terminal, but we need to declare it in nix anyways
      # if there will be at any point any other terminal, we have to activate it here
      # and check whether or not it is declared in home-manager
      zsh.enable = true;
    }
  ];
}
