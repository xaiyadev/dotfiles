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
let
    cfg = config.${namespace}.tools.neovim;
in
{
    options.${namespace}.tools.neovim = {
        enable = mkEnableOption "My own neovim config ^^";

        discord = {
          rpc = {
            enable = mkEnableOption "If the discord RPC should be enabled";
            anonym = mkEnableOption "If the discord RPC should not show project names and file names";
          };
        };
    };

    config = mkIf cfg.enable {
      home.packages = [ pkgs.ripgrep ];

      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        viAlias = true;

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

				globals = 
        {
          number = true;

					expandtab = true;
					shiftwidth = 4;
					tabstop = 4;
				};

        colorschemes.rose-pine.enable = true;

	      plugins = {
          lsp = { # Language Server
            enable = true;
	          inlayHints = true;
              servers = {
                ts_ls.enable = true; # TS/JS
                cssls.enable = true; # CSS
                html.enable = true; # HTML
                phpactor.enable = true; # PHP

	              nil_ls.enable = true; # Nix
                dockerls.enable = true; # Docker
                bashls.enable = true; # Bash

                vuels = { # Vue
                  enable = true;
                  package = pkgs.vue-language-server;
                };

              };
          };

	        cmp = { # Auto Completion
	          enable = true;
	          autoEnableSources = true;

	          settings = {
	            sources = [
		            { name = "nvim_lsp"; }
                { name = "treesitter"; }
	            ];

	            mapping = {
		            "<C-Space>" = "cmp.mapping.complete()";
		            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
		            "<C-e>" = "cmp.mapping.close()";
		            "<C-f>" = "cmp.mapping.scroll_docs(4)";
		            "<CR>" = "cmp.mapping.confirm({ select = true })";
		            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })";
		            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })";
	            };
	          };
	        };

          neocord = mkIf cfg.discord.rpc.enable {
            enable = true;
            settings = {
              global_timer = true;
              logo = "https://repository-images.githubusercontent.com/325421844/ecb73f47-cb89-4ee0-a0fd-9743c2f3569a"; # Nixvim logo
              
              # anonymous mode
              enable_line_number = mkIf cfg.discord.rpc.anonym true;

            };
          };


	        gitblame.enable = true; # Blame code in normal mode

	        
          telescope = { # Search through the Project
            enable = true;

            extensions = {
              file-browser.enable = true;
              undo.enable = true;
            };

            keymaps = {
              /* Ctrl-F - Searching utilities */
              "<C-F>f" = { # search for files
                action = "find_files";
                options.desc = "Search for files in telescope";
              };

              "<C-F>" = { # search through files
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

          barbar = {
            enable = true;
            keymaps = {
              close.key = "<A-q>";

              next.key = "<A-l>";
              last.key = "<A-h>";

            };   
          };

          auto-session.enable = true;

          treesitter.enable = true;
	       
          auto-save.enable = true;

          notify = {
            enable = true;
            fps = 120;
          };


          web-devicons.enable = true; # Icons; Required by other plugins

	      };
      };
    };
}
