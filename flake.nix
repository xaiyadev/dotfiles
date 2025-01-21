{
  inputs = {
    /* package repositorys */
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };

    /* Overlays and software tweaks */
    nixpkgs-wayland = { url = "github:nix-community/nixpkgs-wayland"; inputs.nixpkgs.follows = "nixpkgs"; };

    /* Software flakes */
    nixvim = { url = "github:nix-community/nixvim"; inputs.nixpkgs.follows = "nixpkgs"; };
    spicetify-nix = { url = "github:Gerg-L/spicetify-nix"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixcord = { url = "github:kaylorben/nixcord"; inputs.nixpkgs.follows = "nixpkgs"; };
    zen-browser = { url = "github:MarceColl/zen-browser-flake"; inputs.nixpkgs.follows = "nixpkgs"; }; # The Zen-browser flake has no module, only packages
    # Neptune is right now bugged; waiting for my PR
    neptune = { url = "github:uwu/neptune"; inputs.nixpkgs.follows = "nixpkgs"; };

    /* Security flakes */
    agenix = { url = "github:ryantm/agenix"; inputs.nixpkgs.follows = "nixpkgs"; };
    agenix-rekey = { url = "github:oddlama/agenix-rekey"; inputs.nixpkgs.follows = "nixpkgs"; };
    
    /* Snowfall framework */
    snwofall-lib = { url = "github:snowfallorg/lib"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, ...}@inputs: (inputs.snwofall-lib.mkFlake {
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

      # Add overlays to configuration
      overlays = with inputs; [ 
        # Improved wayland packages
        nixpkgs-wayland.overlay 

        # Overwrite age modules with age-nix modules
        agenix-rekey.overlays.default

        # Software overlays
        neptune.overlays.default
      ];

      # Add modules to all NixOS systems
      systems.modules.nixos = with inputs; [
        # installing agenix modules
        agenix.nixosModules.default
        agenix-rekey.nixosModules.default
      ];

      # add modules to all home-manager instances
      homes.modules = with inputs; [
        spicetify-nix.homeManagerModules.default
        nixcord.homeManagerModules.nixcord

        nixvim.homeManagerModules.nixvim
      ];

    })

    // {
      # Configuring agenix-rekey itself
      agenix-rekey = inputs.agenix-rekey.configure {
        userFlake = inputs.self;
        nixosConfigurations = inputs.self.nixosConfigurations;
      };
    };
}
