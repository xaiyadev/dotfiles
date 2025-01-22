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
    home.packages = [ pkgs.ripgrep ];
    programs.nixvim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      
      # Configuration for defaulting neovim as the new editor
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;

      # Specific configuration option for the Editor
      globalOpts = {
          number = true;
          expandtab = true;
          shiftwidth = 4;
          tabstop = 4;
          smartindent = true;


          clipboard = "unnamedplus"; # Use system clipboard
          
          termguicolors = true;
          incsearch = true;
      };

      files = {
        # You can add any any anguage here, just add "ftplugin/LANG.lua"
        "ftplugin/nix.lua" = {
          opts = {
            shiftwidth = 2;
            tabstop = 2;
      	  };
      	};
      };

      colorschemes.rose-pine.enable = true;

      plugins = {

        direnv = enabled;

        # Language Server
        lsp = mkIf cfg.plugins.lsp.enable {
          enable = true;
          inlayHints = true;
          
          servers = {
            ts_ls = enabled; # TS/JS
            cssls = enabled; # CSS
            html = enabled; # HTML
            phpactor = enabled; # PHP

            dockerls = enabled; # Docker
            bashls = enabled; # Bash
            
            nixd = { # Nix
              enable = true;

              extraOptions = 
              let
                flake = ''(builtins.getFlake "${inputs.self}")'';
              in
              {
                nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
                options.nixvim.expr = "${flake}.packages.${system}.nvim.options";
              };
            };

          };
        };
        
        
        # Auto Complete
        
        coq-nvim = {
          enable = true;
          installArtifacts = true;

          settings.auto_start = true;
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
            file-browser = {
              enable = true;
              settings = {
                depth = 1;
              };
            };

            undo.enable = true;
          };

          keymaps = {
            "<C-P>f" = {
              action = "find_files";
              options.desc = "Search for files in telescope";
            };

            "<C-P>" = {
              action = "live_grep";
              options.desc = "Search through the all files for specific words";
            };

            "<C-P>p" = {
              action = "file_browser";
              options.desc = "Search through the root direcotry";
            };

            "<C-P>u" = {
              action = "undo";
              options.desc = "The changes you have done in that file, listed";
            };
          };
        };

        gitblame = mkIf cfg.plugins.gitblame.enable enabled;

        treesitter = mkIf cfg.plugins.treesitter.enable {
          enable = true;
            
          settings = {
            auto_install = true;

            folding = true;
            highlight.enable = true;
          };

        };

        auto-save = mkIf cfg.plugins.auto-save.enable enabled;
        auto-session = mkIf cfg.plugins.auto-session.enable enabled;

        web-devicons = enabled; # Required by other plugins that use icons
        
      };


    };
  };
}

