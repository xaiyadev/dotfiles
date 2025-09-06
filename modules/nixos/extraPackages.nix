# Packages that are to small to put into a config, but still important!
{
  lib,
  config,
  self,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;

  inherit (self.lib.validation) anyHomeModuleActive;
  prof = config.sylveon.profiles;
in
{

  imports = [ # TODO: only if gaming profile?
      inputs.aagl.nixosModules.default
  ];

  config = {
    programs = mkMerge [
      (mkIf (prof.graphical.enable) {
        # gnome configuration
        dconf.enable = true;
    
        # Gnome keyring manager
        seahorse.enable = true;
      })
    
      (mkIf (prof.gaming.enable) {
        steam = {
          dedicatedServer.openFirewall = true;
          localNetworkGameTransfers.openFirewall = true;
          remotePlay.openFirewall = true;
    
          extest.enable = true;
          protontricks.enable = true;
          gamescopeSession.enable = true;
        };
    
        sleepy-launcher.enable = true;
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
    
    environment.systemPackages = mkMerge [
      (mkIf prof.gaming.enable [
        pkgs.prismlauncher
        pkgs.lutris # TODO: home-manager configuration?
      ])
    ];
  };
}
