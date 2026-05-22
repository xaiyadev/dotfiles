{ lib, config, pkgs, inputs', inputs, ... }:
let
  inherit (lib) mkIf;

in
{
  config = mkIf config.sylveon.profiles.user.music.enable {
    sylveon.packages = {
      inherit (pkgs)
        pear-desktop # Youtube music
        high-tide # tidal
        ;
    };
  };
}
