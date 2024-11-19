{
  inputs = {
    /* unstable packages pulled from github */
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    
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
          name = "xayah-flake";
          title = "Xayah's Flake";
        };
      };

      /* System configuration */

      # Add modules to all NixOS systems
      systems.modules.nixos = with inputs; [ ];

    };
}
