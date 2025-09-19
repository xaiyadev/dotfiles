{ lib, config, ... }:
let
  inherit (lib) mkMerge mkIf;

  cfg = config.sylveon.cli.neovim;
in
{
  programs.nixvim.plugins = {
    cord = {
      enable = true; # TODO: disable for blmedia account

      settings = {
        display = {
          swap_fields = true;

          theme = "atom";
          flavor = "accent";
        };

        timestamp.shared = true;

        editor = {
          tooltip = "NixOS managed VIM (sylveon flake)";
          icon = "https://raw.githubusercontent.com/IogaMaster/neovim/main/.github/assets/nixvim-dark.webp";
        };

        text = mkMerge [
          {
            file_browser = "Browsing through project";
          }

          (mkIf cfg.anonymous {
            workspace = "In anonymised project";
            editing = "Editing anonymised file";
          })
        ];
      };
    };
  };
}
