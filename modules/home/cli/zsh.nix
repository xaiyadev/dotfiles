{ self, config, pkgs, ... }:
let
  inherit (self.lib.modules) mkPackageOpt;

  inherit (builtins)
    fetchurl
    readFile
    fromTOML
    ;

  cfg = config.sylveon.cli.zsh;

in
{
  options.sylveon.cli.zsh =
    mkPackageOpt pkgs.zsh "Whether or not to use zsh as a terminal";

  config = {
    home.shell = {
      enableShellIntegration = !cfg.enable;
      enableZshIntegration = cfg.enable;
    };

    programs.zsh = {
      inherit (cfg) enable package;

      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      plugins = [

        # Nix Shell support
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";

          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "82ca15e638cc208e6d8368e34a1625ed75e08f90"; # v0.8.0
            sha256 = "1l99ayc9j9ns450blf4rs8511lygc2xvbhkg1xp791abcn8krn26";
          };
        }

      ];
    };

    programs.starship = {
      inherit (cfg) enable;

      settings =
        fromTOML (readFile (fetchurl {
            url = "https://starship.rs/presets/toml/bracketed-segments.toml";
            sha256 = "1f373znyrhxix8b3si7w9kqkm8v6z1hwxl62zsiffn7k973pfcgg";
        }));
    };
  };
}