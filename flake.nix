{
  inputs = {
    /* unstable packages pulled from github */
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };

    /* Software flakes */
    nixvim = { url = "github:nix-community/nixvim"; inputs.nixpkgs.follows = "nixpkgs"; };
    spicetify-nix = { url = "github:Gerg-L/spicetify-nix"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixcord = { url = "github:kaylorben/nixcord"; inputs.nixpkgs.follows = "nixpkgs"; };
    zen-browser = { url = "github:MarceColl/zen-browser-flake"; inputs.nixpkgs.follows = "nixpkgs"; }; # The Zen-browser flake has no module, only packages
    
    /* Snowfall framework */
    snwofall-lib = { url = "github:snowfallorg/lib"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs: inputs.snwofall-lib.mkFlake {
      inherit inputs;
      channels-config.allowUnfree = true;
      src = ./.;

      
      /* Snowfall internal settings */
      snowfall = {
        namespace = "sylveon"; # 🏳️‍⚧️

        meta = {
          name = "xaiya-flake";
          title = "Xaiya's Flake";
        };
      };

      /* System configuration */

      # Add modules to all NixOS systems
      systems.modules.nixos = with inputs; [ ];

      # add modules to all home-manager instances
      homes.modules = with inputs; [
        spicetify-nix.homeManagerModules.default
        nixcord.homeManagerModules.nixcord

        nixvim.homeManagerModules.nixvim
      ];

    };
}
