{ pkgs, config, ... }: {
   home.username = "workaholic";
   home.homeDirectory = "/home/workaholic";

   imports = [
        ../../modules/spotify
        ../../modules/obsidian/home-config.nix
   ];

    home.packages = with pkgs; [
          jetbrains.phpstorm
          teams-for-linux
          enpass
          thunderbird
                  ungoogled-chromium
    ];


   # Programm Settings for only that specific User
   programs.git = {
     enable = true;
     package = pkgs.gitFull;
     userName = "Danil Schumin";
     userEmail = "d.schumin@blmedia.de";

     extraConfig = {
         commit.gpgsign = true;
         gpg.format = "ssh";
         user.signingkey = "~/.ssh/bitbucket_ssh_key.pub";
         safe.directory = "/srv/shared/obsidian/obsidian-sync";
     };
   };


   programs.chromium = {
   enable = true;
    initialPrefs = {
        "first_run_tabs" = [
            "https://semiko.dev"
            "https://timebutler.de"
            "https://trello.com"
            "https://bl-projekte.de"
        ];
    };

    extraOpts = {
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [
        "de"
        "en-US"
      ];
    };

    extensions = [
      "kmcfomidfpdkfieipokbalgegidffkal" # enpass
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "oldceeleldhonbafppcapldpdifcinji" # Language Tool
      "kedbaefjfjpplphppofakpfldhimhcio" # NS Lookup
      "gppongmhjkpfnbhagpmjfkannfbllamg" # Wappalyzer - Lookup Website Info
      "mmioliijnhnoblpgimnlajmefafdfilb" # Shazam
      "dhdgffkkebhmkfjojejmpbldmpobfkfo" # Tampermonkey // TODO: Add JSON local
      "kililblhcfpodipkcbobnbgnbbhgbkji" # Pretty JSON
    ];

   };

   home.stateVersion = "23.11";
   programs.home-manager.enable = true;
}
