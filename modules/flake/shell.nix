{
  perSystem =
    {
      pkgs,
      inputs',
      config,
      ...
    }:
    {
      devShells = {
        default = pkgs.mkShell {
          name = "dotfiles";
          meta.description = "Development environment for the repository 'dotfiles'";

          packages = [
            pkgs.gitMinimal # Add git when it is not already installed
            inputs'.agenix-rekey.packages.default # secrets management
            pkgs.nixfmt-rfc-style # nix formatter
            pkgs.nix-output-monitor # get clean diff between generations
          ];
        };
      };
    };
}