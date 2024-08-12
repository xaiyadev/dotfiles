{
  description = "Breaking's Nixos Configuration v2";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
        url = "github:ezKEa/aagl-gtk-on-nix/release-24.05";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, spicetify-nix, catppuccin, aagl, ... } @ inputs: {

        nixosConfigurations.nixos-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; inherit spicetify-nix; };
        modules = [
          ./hosts/nixos-laptop

          # User import
          ./users/semiko
          ./users/workaholic

          catppuccin.nixosModules.catppuccin

          home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;

              home-manager.users.semiko = {
                imports = [
                    ./users/semiko/home.nix
                    catppuccin.homeManagerModules.catppuccin
                 ];
              };

              home-manager.users.workaholic = {
                imports = [
                    ./users/workaholic/home.nix
                    catppuccin.homeManagerModules.catppuccin
                 ];
              };
            }
          ];
        };


        nixosConfigurations.nixos-tower = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; inherit spicetify-nix; };
        modules = [
          ./hosts/nixos-tower

          # User import
          ./users/semiko

          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;

              home-manager.users.semiko = {
                imports = [
                    ./users/semiko/home
                    catppuccin.homeManagerModules.catppuccin
                 ];
              };
            }
          ];
        };

        /* Virt-machine for transforming my ubuntu Server into a NixOS server */
        nixosConfigurations.nixos-virt = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixos-virt

          # User import
          ./users/semiko
           
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;

              home-manager.users.semiko = {
                imports = [ ./users/semiko/home/server.nix ];
              };
            }
          ];
        };
  };
}
