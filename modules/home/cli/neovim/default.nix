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

      keymaps = [
        {
          action = ''<cmd>NvimTreeToggle<cr>'';
          key = "<C-n>";
        }
      ];

      colorschemes.rose-pine.enable = true;

      plugins = {
        # Language Server
        lsp = {
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
        neocord =  {
          enable = true;
          settings.global_timer = true;
        };

        # Search Engine
        telescope = {
          enable = true;

          settings = {
            defaults = {
              sorting_strategy = "ascending";
              layout_config = {
                prompt_position = "top";
                preview_width = 0.5;
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
            
            live-grep-args = enabled;
            ui-select = enabled;
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
          };
        };

        bufferline = {
          enable = true;
          settings = {
            options = {
              diagnostics = "nvim_lsp";
              diagnostics_indicator.__raw = ''
                function(count, level, diagnostics_dict, context)
                  local s = ""
                    for e, n in pairs(diagnostics_dict) do
                      local sym = e == "error" and " "
                        or (e == "warning" and " " or "" )
                  
                    if(sym ~= "") then
                      s = s .. " " .. n .. sym
                    end
                  end
                  return s
                end
              '';

              show_close_icons = false;
              show_buffer_close_icons = false;

              middle_mouse_command = "bdelete! %d";
              rbrightnessctlight_mouse_command = null; # TODO: null does not work, why?

              numbers = "ordinal";
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

        alpha = {
          enable = true;
          theme = null;

          layout = [
            {
              type = "padding";
              val = 2;
            }

            {
              opts = {
                hl = "Type";
                position = "center";
              };

              type = "text";

              val = [
                "∵*.•´¸.•*´✶´♡"
                "° ☆ °˛*˛☆_Π______*˚☆*"
                "˚ ˛★˛•˚*/______/ ~⧹。˚˚"
                "˚ ˛•˛•˚｜ 田田 ｜門｜ ˚*"
                "🌷╬╬🌷╬╬🌷╬╬🌷╬╬🌷"

              ];
            }

            {
              type = "padding";
              val = 2;
            }

            {
              type = "group";
              val = [
                {
                  on_press.__raw = "function() vim.cmd[[ene]] end";
                  opts.position = "center";

                  type = "button";
                  val = "  New file";
                }

                {
                  on_press.__raw = "function() vim.cmd[[Telescope find_files]] end";
                  opts.position = "center";

                  type = "button";
                  val = "  Find file";
                }

                {
                  type = "padding";
                  val = 1;
                }

                {
                  on_press.__raw = "function() vim.cmd[[Telescope projects]] end";
                  opts.position = "center";

                  type = "button";
                  val = "  Projects";
                }

                {
                  on_press.__raw = "function() vim.cmd[[qa]] end";
                  opts.position = "center";

                  type = "button";
                  val = "  Quit";
                }
              ];
            }

            {
              type = "padding";
              val = 1;
            }

            {
              type = "text";
              val.__raw = ''
              function()
                  local v = vim.version()
                  local vString = string.format("v%d.%d.%d", v.major, v.minor, v.patch)


                  return 'Neovim ' .. vString
              end
              '';
              opts = { hl = "Comment"; position = "center"; };

            }
 
          ];
        };

        project-nvim = {
          enable = true;
          enableTelescope = true;
        };

        markview = {
          enable = true;

          settings = {
            hybrid_modes = [ "i" ];
            hodes = [ "n" "i" "no" "c" ];
          };
        };

        obsidian = {
          enable = true;
          
          settings = {
            workspaces = [
              {
                name = "default";
                path = "/srv/Obsidian";
              }
            ];
          };
        };

        toggleterm = {
          enable = true;
          settings.size = 10;
        };

        nvim-tree = {
          enable = true;
          actions.openFile.quitOnOpen = true;

          diagnostics = enabled;
          modified = enabled;
          renderer.indentMarkers = enabled;
        };

        snacks = { # QoL Plugins
          enable = true;
          settings = {
            animate = enabled;
            bigfile = enabled;
            
            notifier = enabled;
            notify = enabled;

            quickfile = enabled;
            rename = enabled;
            words = enabled;
          };
        };

        indent-blankline = {
          enable = true;
          settings.scope.enabled = false;
        };

        auto-save = enabled;
        auto-session = enabled;

        gitblame = enabled;

        direnv = enabled;
        
        web-devicons = enabled; # Required by other plugins that use icons
        lz-n = enabled; # Lazy loading
      };
    };
  };
}

