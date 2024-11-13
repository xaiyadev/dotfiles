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
       jetbrains.webstorm
       zed-editor


       /* --- Games --- */
       # steam TODO: cant be installed on home-manager; needs to be system-wide

       inputs.agenix.packages.${system}.default

     ];

    # TODO: infinite loop when using ${namespace} (?)
    semiko = {
      desktop.config.sway = {
        enable = true;
        devices.huckleberry = true;
      };

      programs = {
        spotify.enable = true;
        vesktop.enable = true;
        vscode.enable = true;

        games = {
          minecraft = {
            enable = true;
            package = pkgs.lunar-client;

            resourcepacks.install = true;
            shaderpacks.install = true;
            mods.install = true;
          };
        };
      };

      tools = {
        git.enable = true;
        neovim = {
          enable = true;
          discord.rpc.enable = true;
        };
      };
    };

     # Will be created here, makes it easier with extension managment
     programs.chromium = {
         enable = true;
         package = pkgs.chromium.override { enableWideVine = true; };

         extensions = [
            { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
            { id = "oldceeleldhonbafppcapldpdifcinji"; } # Language Tool
            { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
            { id = "agjnjboanicjcpenljmaaigopkgdnihi"; } # premid extension

            { id = "bkkmolkhemgaeaeggcmfbghljjjoofoh"; } # catppuccin Theme
         ];

         dictionaries = with pkgs.hunspellDictsChromium; [ en_US de_DE ];
     };
    
      home.stateVersion = "24.05";
}
