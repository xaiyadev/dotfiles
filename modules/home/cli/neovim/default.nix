{
  lib,
  pkgs,
  inputs,

  namespace, # The flake namespace, set in flake.nix. If not set, defaults to "internal".
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.

  config,
  specialArgs,
  ...
}:
with lib;
with lib.${namespace};
let
    cfg = config.${namespace}.cli.neovim;
in
{
  options.${namespace}.cli.neovim = with types; {
      enable = mkBoolOpt false "Whether or not to enable the neovim editor";

      plugins = { # All plugins are activated on default
        lsp.enable = mkBoolOpt true "Whether or not to enable the language server plugin";
        cmp.enable = mkBoolOpt true "Whether or not to enable the auto complition plugin";
        discord.enable = mkBoolOpt true "Whether or not to enable the integration for discord rich presence";
        telescope.enable = mkBoolOpt true "Whether or not to enable the Search engine";
        gitblame.enable = mkBoolOpt true "Wheter or not to enable the git blame plugin";
        treesitter.enable = mkBoolOpt true "Wheter or not to enable auto completion helper or something like that";
        auto-save.enable = mkBoolOpt true "Wheter or not to enable auto saving files";
        auto-session.enable = mkBoolOpt true "Wheter or not to enable automating session with files";
      };
  };

  config = mkIf cfg.enable {
    # Software needed for nixvim plugins
    home.packages = [ pkgs.ripgrep ];

    programs.nixvim = {
      enable = true;

      # Configuration for defaulting neovim as the new editor
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;

      # Specific configuration option for the Editor
      globals = {
        number = true;
        expandtab = true;
        shiftwidth = 4;
        tabstop = 4;
      };

      files = {
        # You can add any any anguage here, just add "ftplugin/LANG.lua"
        "ftplugin/nix.lua" = {
          opts = {
            number = true;
            expandtab = true;
            shiftwidth = 2;
            tabstop = 2;
      	  };
      	};
      };

      colorschemes.rose-pine.enable = true;

      plugins = {

        # Language Server
        lsp = mkIf cfg.plugins.lsp.enable {
          enable = true;
          inlayHints = true;

          servers = { # TODO: add langauge servers to devenv
            ts_ls = enabled; # TS/JS
            cssls = enabled; # CSS
            html = enabled; # HTML
            phpactor = enabled; # PHP

            nil_ls = enabled; # Nix
            dockerls = enabled; # Docker
            bashls = enabled; # Bash
          };
        };

        # Auto Complete
        cmp = mkIf cfg.plugins.cmp.enable {
          enable = true;
          autoEnableSources = true; # Implements the sources into the plugin list automaticly

          settings = {
            sources = [
                { name = "nvim_lsp"; } # CMP integration for language server
                { name = "treesitter"; } # Treesitter integration for cmp
            ];
          };

          mapping = { # Configurate Keybindings to navigate the autocompletion options
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })";
          };
        };


        # Discord Rich Presence
        neocord = mkIf cfg.plugins.discord.enable {
          enable = true;
          settings.global_timer = true;
        };

        # Search Engine
        telescope = mkIf cfg.plugins.telescope.enable {
          enable = true;

          extensions = {
            file-browser.enable = true;
            undo.enable = true;
          };

          keymaps = {
            "<C-F>f" = {
              action = "find_files";
              options.desc = "Search for files in telescope";
            };

            "<C-F>" = {
              action = "live_grep";
              options.desc = "Search through the all files for specific words";
            };

            "<C-F>p" = {
              action = "file_browser";
              options.desc = "Search through the root direcotry";
            };

            "<C-F>u" = {
              action = "undo";
              options.desc = "The changes you have done in that file, listed";
            };

            "<C-G>" = {
              action = "git_status";
              options.desc = "Get the Status changes of files";
            };
          };
        };

        gitblame = mkIf cfg.plugins.gitblame.enable enabled;
        treesitter = mkIf cfg.plugins.treesitter.enable enabled;

        auto-save = mkIf cfg.plugins.auto-save.enable enabled;
        auto-session = mkIf cfg.plugins.auto-session.enable enabled;

        web-devicons = enabled; # Required by other plugins that use icons

      };


    };
  };
}
