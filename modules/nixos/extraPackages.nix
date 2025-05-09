# Packages that are to small to put into a config, but still important!
{ lib, config, self, ... }:
let
  inherit (lib) mkIf mkMerge;

  inherit (self.lib.validation) isGraphical;
in
{
  programs = mkMerge [
    (mkIf (isGraphical config) {
      # gnome gtk configuration
      dconf.enable = true;

      # Gnome keyring manager
      seahorse.enable = true;
    })

    {
      zsh.enable = true; # TODO: get the configuration of any home and enable this if true
    }
  ];
}