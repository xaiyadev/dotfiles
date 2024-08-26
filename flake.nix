{
  description = "Breaking's Nixos Configuration v2";

  inputs = {
    agenix.url = "github:ryantm/agenix";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    copyparty.url  = "github:9001/copyparty";

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

  outputs = {self, nixpkgs, home-manager, spicetify-nix, catppuccin, aagl, agenix, copyparty, ... } @ inputs: {

        nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; inherit spicetify-nix; };
        modules = [
          ./hosts/pineapple

          # User import
          ./users/semiko
          ./users/workaholic

          catppuccin.nixosModules.catppuccin
          agenix.nixosModules.default


          home-manager.nixosModules.home-manager
            {
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs;

              home-manager.users.semiko = {
                imports = [
                    ./users/semiko/home/default.nix
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


        nixosConfigurations.tower = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; inherit spicetify-nix; };
        modules = [
          ./hosts/huckleberry

          # User import
          ./users/semiko
          ./users/medea

          catppuccin.nixosModules.catppuccin
          agenix.nixosModules.default


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
              home-manager.users.medea = {
                imports = [
                    ./users/medea/home.nix
                    catppuccin.homeManagerModules.catppuccin
                 ];
              };
            }
          ];
        };

        /* Virt-machine for transforming my ubuntu Server into a NixOS server */
        nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; inherit copyparty; };
        modules = [
          ./hosts/apricot

          # User import
          ./users/semiko
           
          catppuccin.nixosModules.catppuccin
          agenix.nixosModules.default
          copyparty.nixosModules.default


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
