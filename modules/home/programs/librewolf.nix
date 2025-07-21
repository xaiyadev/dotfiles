{
  config,
  lib,
  self,
  pkgs,
  ...
}:
let

  inherit (lib)
    mkMerge
    mkIf
    genAttrs
    ;

  inherit (self.lib.modules) mkPackageOpt;

  cfg = config.sylveon.programs.librewolf;
in
{

  options.sylveon.programs.librewolf = mkPackageOpt pkgs.librewolf "Whether or not to enable chromium";

  config = mkIf cfg.enable {
    programs.librewolf = {
      inherit (cfg) package;

      # Install German and english languages
      languagePacks = [
        "en-GB"
        "de"
      ];

      # Enable cookies for librewolf
      settings = {
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
      };

      policies = {
        ExtensionSettings =
          genAttrs
            [
              "uBlock0@raymondhill.net"
              "languagetool-webextension@languagetool.org"
              "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" # styl-us
              "sponsorBlocker@ajay.app"
              "FirefoxColor@mozilla.com"
              "firefox-enpass@enpass.io" # TODO: only blmedia?
            ]
            (ext: {
              installation_mode = "force_installed";
              private_browsing = true;
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${ext}/latest.xpi";
            });

        DisplayBookmarksToolbar = "never";
      };

      profiles = {
        default = {

          # Extensions are managed via policies, not here!
          extensions = {
            force = true;
            settings = {
              # ColorTheme is managed by stylix

              "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".settings = {
                dbInChromeStorage = true; # required for Stylus
              };

            };
          };

          search = {
            force = true;
            default = "google";

            engines = {
              MyNixOS = {
                name = "MyNixOS";

                urls = [
                  {
                    template = "https://mynixos.com/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
                definedAliases = [ "@nix" ];
              };

              ddg.metaData.hidden = true;
              wikipedia.metaData.hidden = true;

              google.metaData.alias = "@g";

            };
          };
        };
      };
    };

    stylix.targets.librewolf = {
      colorTheme.enable = true;
      profileNames = [ "default" ]; # https://stylix.danth.me/options/modules/firefox.html
    };
  };
}
