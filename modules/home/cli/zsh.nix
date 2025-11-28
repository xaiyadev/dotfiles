{
  pkgs,
  ...
}:
let

  inherit (builtins)
    fetchurl
    readFile
    fromTOML
    ;
in
{
  home.shell.enableZshIntegration = true;

  programs.zsh = {
    enable = true;

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
    enable = true;

    settings = fromTOML (
      readFile (fetchurl {
        url = "https://starship.rs/presets/toml/bracketed-segments.toml";
        sha256 = "sha256-FQHzfWYEcllLCmH2nx52J31Jw8Yy6aDAoOVdxWxhcAU="; # TODO: make this auto update? (versioned)
      })
    );
  };
}
