{ inputs, pkgs, ... }:
{
  programs.vicinae.extensions = 
    with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; 
      [ 
        protondb-search
        github
      ];
}
