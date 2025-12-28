{
  config,
  lib,
  self,
  pkgs,
  ...
}:
let

  inherit (lib)
    mkIf
    genAttrs
    ;

  inherit (lib.types) bool;

  inherit (self.lib.modules) mkOpt;

  cfg = config.sylveon.programs.librewolf;
in
{

  options.sylveon.programs.librewolf = {
    enable = mkOpt bool false "Enable webbrowser based on firefox";
  };

  config = mkIf cfg.enable {
    programs.librewolf = {
      enable = true;

      languagePacks = [ "en-GB" "de" ];

      # Settings usually disabled by librewolf, enabled again for convience reasons
      settings = {
        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;
        "webgl.disabled" = false;
        "privacy.fingerprintingProtection" = false;
      };

      policies = {
        DisplayBookmarksToolbar = "never";
        DisableFirefoxAccounts = true;
        DisableFeedbackCommands = true;

        ExtensionSettings =
          genAttrs
            [
              "uBlock0@raymondhill.net"
              "sponsorBlocker@ajay.app"
              "FirefoxColor@mozilla.com"
              "firefox-enpass@enpass.io"
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" # Bitwarden
            ]
            (ext: {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${ext}/latest.xpi";
            });
      };

      profiles.default = {
        # TODO: containers?
        containersForce = true;
        extensions.force = true; # Needed for catppuccin

        settings = {
          # Default page should be my homepage
          "browser.startup.homepage" = "https://xaiya.dev";
        };

        search = {
          force = true;
          default = "ddg";

          engines = {
            MyNixOS = {
              name = "MyNixOS";
              urls = [{
                  template = "https://mynixos.com/search";
                  params = [ { name = "q"; value = "{searchTerms}"; } ];
              }];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
              definedAliases = [ "@n" ];
            };

            google.metaData.alias = "@g";
          };
        };
      };
    };

    catppuccin.librewolf = {
      force = true;
      profiles.default.force = true;
    };
  };
}
