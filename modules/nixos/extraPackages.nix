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
  prof = config.sylveon.profiles;
in
{
  programs = mkMerge [
    (mkIf (prof.graphical.enable) {
      # gnome configuration
      dconf.enable = true;

      # Gnome keyring
      seahorse.enable = true;
    })

    (mkIf (prof.gaming.enable) {
      # Setup configuration thingies for steam

      # needs to be enabled or the config is not loaded
      # this has to be enabled globaly, so steam will be on every account :(
      steam = {
        enable = true;
        extest.enable = true;
        protontricks.enable = true;

        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
      };
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
