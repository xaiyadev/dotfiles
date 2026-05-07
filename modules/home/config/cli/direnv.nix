{ config, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    silent = true;

    enableZshIntegration = config.programs.zsh.enable;

    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv.override { nix = config.nix.package; };
    };

     # store direnv in cache and not per project
     # https://github.com/direnv/direnv/wiki/Customizing-cache-location#hashed-directories
     stdlib = ''
       : ''${XDG_CACHE_HOME:=$HOME/.cache}
       declare -A direnv_layout_dirs

       direnv_layout_dir() {
         echo "''${direnv_layout_dirs[$PWD]:=$(
           echo -n "$XDG_CACHE_HOME"/direnv/layouts/
           echo -n "$PWD" | sha1sum | cut -d ' ' -f 1
         )}"
       }
     '';
  };
}