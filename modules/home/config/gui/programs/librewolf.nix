{
  config,
  lib,
  pkgs,
  ...
}:
let

  inherit (lib)
    genAttrs
    mkEnableOption
    ;

  cfg = config.sylveon.programs.librewolf;
in
{

  options.sylveon.programs.librewolf.enable = mkEnableOption "enable web-browser based on firefox";

  config = {
    programs.librewolf = {
      inherit (cfg) enable;

      languagePacks = [
        "en-GB"
        "de"
      ];

      settings = {
        "browser.fullscreen.autohide" = false;

        "webgl.disabled" = false;
        "privacy.fingerprintingProtection" = false;
        "browser.translations.enable" = false;

        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;

        "extensions.abuseReport.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "browser.contentblocking.report.lockwise.enabled" = false;

        "identity.fxaccounts.enabled" = false;
        "identity.fxaccounts.toolbar.enabled" = false;
        "identity.fxaccounts.pairing.enabled" = false;
        "identity.fxaccounts.commands.enabled" = false;
        "privacy.clearOnShutdown.history" = true;

        "privacy.clearOnShutdown.cookies" = false;
        "network.cookie.lifetimePolicy" = 0;

        # disable notifications
        "dom.push.enabled" = false;
        "dom.push.connection.enabled" = false;
        "dom.battery.enabled" = false;
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
              "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" # Stylus
              "{446900e4-71c2-419f-a6a7-df9c091e268b}" # Bitwarden
            ]
            (ext: {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${ext}/latest.xpi";
            });
      };

      profiles.default = {
        extensions = {
          force = true; # Needed for catppuccin

          settings = {
            # stylus themes need to be manually imported from now
            # please create and import a new style file from here: https://catppuccin-userstyles-customizer.uncenter.dev/
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".settings = {
              dbInChromeStorage = true; # required for Stylus
            };
          };
        };

        settings = {
          # Default page should be my homepage
          "browser.startup.homepage" = "https://xaiya.dev";
        };

        search = {
          force = true;
          default = "kagi";

          engines = {
            MyNixOS = {
              name = "MyNixOS";
              urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
              definedAliases = [ "@n" ];
            };

            kagi = {
              name = "Kagi";
              urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
            };

            google.metaData.alias = "@g";
            bing.metaData.hidden = true;
          };
        };
      };
    };
  };
}
