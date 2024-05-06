{ lib, pkgs, config, ... }: {
   home.username = "semiko";
   home.homeDirectory = "/home/semiko";

   imports = [
        ../../modules/spotify
        ../../modules/obsidian/home-config.nix
    ];

    home.packages = with pkgs; [
          jetbrains.webstorm
    ];

   home.stateVersion = "23.11";
   programs.home-manager.enable = true;


   # Programm Settings for only that specific User
   programs.git = {
     enable = true;
     package = pkgs.gitFull;
     userName = "Danil Schumin";
     userEmail = "danil80sch@gmail.com";

     extraConfig = {
         commit.gpgsign = true;
         gpg.format = "ssh";
         user.signingkey = "~/.ssh/gitlab_ssh_key.pub";
         safe.directory = "/srv/shared/obsidian/obsidian-sync";
     };
   };

  programs.chromium = {
  enable = true;
   # TODO: extra Opts and other shit make working, thy :3

   /*initialPrefs = {
       "first_run_tabs" = [
           "https://semiko.dev"
       ];
   };
*/

/*   extraOpts = {
     "PasswordManagerEnabled" = false;
     "SpellcheckEnabled" = true;
     "SpellcheckLanguage" = [
       "de"
       "en-US"
     ];
   };
*/

   # TODO: Automated setup for extensions
   extensions = [
     "kmcfomidfpdkfieipokbalgegidffkal" # enpass
     "nngceckbapebfimnlniiiahkandclblb" # bitwarden
     "oldceeleldhonbafppcapldpdifcinji" # Language Tool
     "kedbaefjfjpplphppofakpfldhimhcio" # NS Lookup
     "gppongmhjkpfnbhagpmjfkannfbllamg" # Wappalyzer - Lookup Website Info
     "mmioliijnhnoblpgimnlajmefafdfilb" # Shazam
     "dhdgffkkebhmkfjojejmpbldmpobfkfo" # Tampermonkey
     "kililblhcfpodipkcbobnbgnbbhgbkji" # Pretty JSON
   ];

  };
}

