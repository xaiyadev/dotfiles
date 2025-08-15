{ 
  pkgs, 
  self, 
  lib, 
  config,
  inputs,
  ... 
}:
let
  inherit (self.lib.modules) mkPackageOpt;

  inherit (lib) 
    mkIf
    mkMerge
    ;

  cfg = config.sylveon.cli.neovim;
  neov-plugins = config.programs.nixvim.plugins;
in
{

  imports = [
    inputs.nixvim.homeModules.nixvim

    ./lsp.nix
    ./telescope.nix
  ];

  options.sylveon.cli.neovim =
    mkPackageOpt pkgs.neovim "vim editor, only better";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.ripgrep
      pkgs.clang
    ];

    programs.nixvim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      enableMan = false;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      keymaps = mkMerge [
        [
          {
            action = "<cmd>bnext<CR>";
            key = "<A-l>";
            options = {
              silent = true;
            };
          }

          {
            action = "<cmd>bNext<CR>";
            key = "<A-h>";
            options = {
              silent = true;
            };
          }

          {
            action = "<cmd>bdelete<CR>";
            key = "<C-w>";
            options = {
              silent = true;
            };
          }
        ]

        (mkIf neov-plugins.nvim-tree.enable [
          {
            action = "<cmd>NvimTreeToggle<CR>";
            key = "<C-N>";
            options = {
              silent = true;
            };
          }
        ])
      ];

      # global options defined for all files
      globalOpts = {
        number = true;

        expandtab = true;
        shiftwidth = 4;
        tabstop = 4;
      };

	
      # extra files that should be added to the neovim runtime
      files = {
        "ftplugin/nix.lua" = {
	        opts = {
            number = true;

            expandtab = true;
	          shiftwidth = 2;
	          tabstop = 2;
	        };
	      };
      };

      # External neovim plugins that will be loaded
      plugins = {
        lualine.enable = true; # TODO: configuration?

        # Ghost message next to line, blaming who wrote the spaghetti
        gitblame = {
          enable = true;

          settings = {
            date_format = "%r";
            message_template = " <summary> • <author> (<date>)";
          };
        };

        # visualize currently open files
        bufferline = {
          enable = true;

          settings = {
            options = {
              show_close_icon = false;
              show_buffer_close_icons = false;
              show_buffer_icons = false;
              
              mode = "buffers";
              modified_icon = "●";
              diagnostics = "nvim_lsp";
            };
          };
        };

        nvim-tree = {
          enable = true;
          autoClose = true;

          settings = {
            diagnostics.enable = true;
            modified.enable = true;
            view.width = "20%";

            actions = {
              open_file.quit_on_open = true;
            };

            renderer = {
              full_name = true;
              indent_markers.enable = true;
            };
          };
        };

        treesitter = {
          enable = true;

          settings = {
            auto_install = true;

            folding = true;
            highlight.enable = true;
          };
        };

        blink-cmp = {
          enable = true;

          settings = {
            keymap = {
              "<tab>" = [ "select_and_accept" "snippet_forward" "fallback" ];
              "<C-space>" = [ "show" "show_documentation" "hide_documentation" ];
              "<down>" = [ "select_next" "fallback" ];
              "<up>" = [ "select_prev" "fallback" ];
            };

            completion = {
              ghost_text.enabled = true;
              list.cycle = {
                from_bottom = false;
                from_top = false;
              };
            };
          };
        };

        cord = {
          enable = false; # TODO: disable for blmedia account

          settings = {
            display = {
              swap_fields = true;

              theme = "atom";
              flavor = "accent";
            };

            editor.icon = "https://raw.githubusercontent.com/IogaMaster/neovim/main/.github/assets/nixvim-dark.webp";
            text.file_browser = "Browsing through project";

          };
        };

        /* Curently bricked TODO */
        project-nvim = {
          enable = false;
          enableTelescope = true;
        };
        
        colorizer.enable = true;

        auto-save.enable = true;
        auto-session.enable = true;

        direnv.enable = true;

        web-devicons.enable = true;
        lz-n.enable = true; # Lazy loading
      };
    };

    stylix.targets.nixvim = {
      plugin = "mini.base16";
      transparentBackground.main = true;
    };

  };
}

