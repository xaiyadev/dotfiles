{
  description = "Breakings Awesome Dotfiles";

  inputs = {
    snowfall-lib = {
        url = "github:snowfallorg/lib";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    agenix.url = "github:ryantm/agenix";

    catppuccin.url = "github:catppuccin/nix";

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.; # needs to be the root of the flake file
      channels-config = {
        allowUnfree = true;
      };

      # configure snowfall settings!
      snowfall = {
        namespace = "semiko"; 

        # Adds flake Metada
        meta = {
          name = "breakings-awesome-dotfiles";
          title = "Breakings Awesome Dotfiles";
        };
      };

      /* Add External Overlays */
      overlays = [ inputs.nixpkgs-wayland.overlay ];

      systems.modules.nixos = with inputs; [
	      lix-module.nixosModules.default
        agenix.nixosModules.default

        catppuccin.nixosModules.catppuccin
        aagl.nixosModules.default
      ];

      homes.modules = with inputs; [
        catppuccin.homeManagerModules.catppuccin
      ];

      systems.hosts.huckleberry.specialArgs = {
          host-name = "huckleberry";
          cattpuccin.flavor = "mocha";
      };

      systems.hosts.pineapple.specialArgs = {
          host-name = "pineapple";
          cattpuccin.flavor = "mocha";

      };

      systems.hosts.apricot.specialArgs = {
          host-name = "apricot";
          cattpuccin.flavor = "mocha";
      };

    };
}
