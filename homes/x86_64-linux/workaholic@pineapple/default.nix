{
    # Snowfall Lib provides a customized `lib` instance with access to your flake's library
    # as well as the libraries available from your flake's inputs.
    lib,
    # An instance of `pkgs` with your overlays and packages applied is also available.
    pkgs,
    # You also have access to your flake's inputs.
    inputs,

    # Additional metadata is provided by Snowfall Lib.
    namespace, # The namespace used for your flake, defaulting to "internal" if not set.
    home, # The home architecture for this host (eg. `x86_64-linux`).
    target, # The Snowfall Lib target for this home (eg. `x86_64-home`).
    format, # A normalized name for the home target (eg. `home`).
    virtual, # A boolean to determine whether this home is a virtual target using nixos-generators.
    host, # The host name for this home.

    # All other arguments come from the home home.
    config,
    ...
}: {
     home.packages = with pkgs; [
       obsidian
       jetbrains.phpstorm
       teams-for-linux
       enpass
     ];

    semiko = {
      desktop.config.sway.enable = true;

      programs = {
        #spotify.enable = true; replaced with TIDAL
        vesktop.enable = true;
      };

      tools = {
        git = {
          enable = true;
          
          email = "d.schumin@blmedia.de";
          name = "Danil Schumin";

          key = "~/.ssh/id_rsa";
        };

	      neovim.enable = true;
      };
    };

     # Will be created here, makes it easier with extension managment
     programs.chromium = {
         enable = true;

         extensions = [
            { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
            { id = "oldceeleldhonbafppcapldpdifcinji"; } # Language Tool
            { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin

            { id = "kmcfomidfpdkfieipokbalgegidffkal"; } # enpass


            { id = "noimedcjdohhokijigpfcbjcfcaaahej"; } # rose pine Theme
         ];

         dictionaries = with pkgs.hunspellDictsChromium; [ en_US de_DE ];
     };

    home.stateVersion = "24.05";
}
