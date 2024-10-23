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
   
    zen-browser.url = "github:MarceColl/zen-browser-flake";

    agenix.url = "github:ryantm/agenix";

    nur.url = "github:nix-community/NUR";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # overlay channels
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

        aagl.nixosModules.default

        # This adds a nur configuration option.
        # Use `config.nur` for packages like this:
        # ({ config, ... }: {
        #   environment.systemPackages = [ config.nur.repos.mic92.hello-nur ];
        # })
        nur.nixosModules.nur
      ];

      homes.modules = with inputs; [ ];

      systems.hosts.huckleberry.specialArgs = {
          host-name = "huckleberry";
      };

      systems.hosts.pineapple.specialArgs = {
          host-name = "pineapple";

      };

      systems.hosts.apricot.specialArgs = {
          host-name = "apricot";
      };

    };
}
