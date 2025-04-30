# Packages that are to small to put into a config, but still important!
{ lib, config, self, ... }:
let
  inherit (lib.modules) mkIf;

  inherit (self.lib.validation) isGraphical;
in
{
  config = mkIf (isGraphical config) {
    programs = {
      # gnome gtk configuration
      dconf.enable = true;

      # Gnome keyring manager
      seahorse.enable = true;
    };
  };
}