{
  description = "A Nix-flake for different Develoment Enviroments";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self , nixpkgs, ... }:
    let pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
    in {
      devShells.x86_64-linux.minecraft = pkgs.mkShell {
        # This will only install a minecraft client, the server should be installed with docker instead.
            packages = with pkgs; [
              # IDE should aready be installed for the user
              lunar-client
              jdk17
              jre17_minimal

            ];
        };
      };
}