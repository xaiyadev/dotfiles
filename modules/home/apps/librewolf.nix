{ config, lib, self, pkgs, ... }:
let

  inherit (self.lib.modules) mkPackageOpt;
  cfg = config.sylveon.apps.librewolf;
in
{

  options.sylveon.apps.librewolf =
    mkPackageOpt pkgs.librewolf "Whether or not to enable chromium";

  config = {
    programs.librewolf = {
      inherit (cfg) enable;

      # Install German and english languages
      languagePacks = [
        "en-GB"
        "de"
      ];

      settings = {
        "privacy.clearOnShutdown.history" = false; # Dont clear history after shutdown
        "privacy.clearOnShutdown.cookies" = false; # Dont clear cookies after shutdown
        "network.cookie.lifetimePolicy" = 0; # Dont remove cookies after a certain time
      };

      profiles = {
        default = {
          extensions.force = true;
        };
      };
    };

    stylix.targets.librewolf = {
      colorTheme.enable = true;
      profileNames = [ "default" ]; # https://stylix.danth.me/options/modules/firefox.html
    };
  };
}