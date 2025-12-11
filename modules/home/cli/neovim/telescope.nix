{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{

  home.packages = mkIf config.programs.nixvim.plugins.telescope.enable [ pkgs.ripgrep ];

  programs.nixvim.plugins = {
    telescope = {
      enable = true;

      settings = {
        defaults = {
          sorting_strategy = "ascending";
          layout_config = {
            prompt_position = "top";
            # preview_width = 0.5;
            width = 0.40;
            height = 0.40;
          };
        };

        pickers = {
          find_files.previewer = false;
          live_grep.theme = "dropdown";
        };
      };

      extensions = {
        file-browser = {
          enable = true;
          settings.respect_gitignore = true;
        };

        advanced-git-search.enable = true;
        live-grep-args.enable = true;
        ui-select.enable = true;

        project.enable = true;
      };

      keymaps = {
        "<C-F>" = {
          action = "find_files";
          options.desc = "Search for files in telescope";
        };

        "<C-G>" = {
          action = "live_grep";
          options.desc = "Search through all files for specific words";
        };
      };
    };
  };
}
