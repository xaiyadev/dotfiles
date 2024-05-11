{ pkgs, ... }: {
    programs.chromium = {
        enable = true;

        extensions = [
            "nngceckbapebfimnlniiiahkandclblb" # bitwarden
            "oldceeleldhonbafppcapldpdifcinji" # Language Tool
            "dhdgffkkebhmkfjojejmpbldmpobfkfo" # Tampermonkey

            "kmcfomidfpdkfieipokbalgegidffkal" # enpass
        ];

        homepageLocation = "https://semiko.dev";

        extraOpts = {
              "SyncDisabled" = true;
              "PasswordManagerEnabled" = false;
              "SpellcheckEnabled" = true;
              "SpellcheckLanguage" = [
                "de"
                "en-US"
              ];
        };
        };
    }