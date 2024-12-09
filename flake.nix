{
  description = "Breakings Awesome Dotfiles";

  inputs = {
    /*Software flakes */

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
	url = "github:Infinidoge/nix-minecraft";
	inputs.nixpkgs.follows = "nixpkgs";
    };

    /* System-important flakes */
    snowfall-lib = {
        url = "github:snowfallorg/lib";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /* Packge sets */
    nur.url = "github:nix-community/NUR";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # overlay channels
    neptune = {
      url = "github:xaiyadev/neptune/bugfix/nix-packages";
    };
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
      overlays = with inputs; [
#       nixpkgs-wayland.overlay
        nix-minecraft.overlay
        neptune.overlays.default
      ];

      /* Add External Software/Modules */
      systems.modules.nixos = with inputs; [
	      lix-module.nixosModules.default
        agenix.nixosModules.default

        nix-minecraft.nixosModules.minecraft-servers

        # This adds a nur configuration option.
        # Use `config.nur` for packages like this:
        # ({ config, ... }: {
        #   environment.systemPackages = [ config.nur.repos.mic92.hello-nur ];
        # })
        nur.modules.nixos.default
      ];

      homes.modules = with inputs; [ nixvim.homeManagerModules.nixvim ];

      systems.hosts.huckleberry.specialArgs = {
          host-name = "huckleberry";
      };

      systems.hosts.pineapple.specialArgs = {
          host-name = "pineapple";

      };

      systems.hosts.apricot.specialArgs = {
          host-name = "tangerine";
      };

    };
}
