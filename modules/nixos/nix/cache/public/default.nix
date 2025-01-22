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
  cfg = config.${namespace}.nix.cache.public;
in {

  options.${namespace}.nix.cache.public = with types; {
    enable = mkBoolOpt false "Whether or not the public caches should be applied";
  };

  config = mkIf cfg.enable {
    nix.settings = {
      substituters = [
        "https://cache.nixos.org/" # Default nixos cache
        "https://devenv.cachix.org/" # Cache for development tools
      ];

      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" # Cache for development tools
      ];

      # This is a temporary solution
      trusted-users = [ "root" "workaholic" "xaiya" ];
    };
  };
}
