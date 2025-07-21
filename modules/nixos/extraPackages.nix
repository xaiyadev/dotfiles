# Packages that are to small to put into a config, but still important!
{
  lib,
  config,
  self,
  ...
}:
let
  inherit (lib) mkIf mkMerge;

  inherit (self.lib.validation) anyHomeModuleActive;
  graphical = config.sylveon.profiles.graphical;
in
{
  programs = mkMerge [
    (mkIf (graphical.enable) {
      # gnome configuration
      dconf.enable = true;

      # Gnome keyring manager
      seahorse.enable = true;
    })

    {
      zsh.enable = (
        anyHomeModuleActive config [
          "sylveon"
          "cli"
          "zsh"
          "enable"
        ]
      );
    }
  ];
}
