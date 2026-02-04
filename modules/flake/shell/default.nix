{
  # include the formatter for this configuration
  imports = [ ./formatter.nix ];

  perSystem =
    {
      pkgs,
      inputs',
      config,
      ...
    }:
    {
      devShells.default = pkgs.mkShellNoCC {
        name = "dotfiles";
        meta.description = "development environment for this flake";

        inputsFrom = [ config.formatter ];

        DIRENV_LOG_FORMAT = "";

        packages = [
          pkgs.gitMinimal # git is needed for flake based configurations
          inputs'.agenix-rekey.packages.default # manging secrets
          config.formatter # nix formatter
          pkgs.nix-output-monitor # detailed diff view between generations
        ];
      };
    };
}
