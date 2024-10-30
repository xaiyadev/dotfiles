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
    };

    config = mkIf cfg.enable {
	      
      programs.nixvim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        viAlias = true;

        colorschemes.rose-pine.enable = true;
        
	plugins = {
          /* Auto-complition */
          lsp = {
            enable = true;
	    inlayHints = true;
            servers = {
              # ts-ls.enable = true; # TS/JS
              ts_ls.enable = true; # TS/JS
              cssls.enable = true; # CSS
              tailwindcss.enable = true; # TailwindCSS
              html.enable = true; # HTML
              astro.enable = true; # AstroJS
              phpactor.enable = true; # PHP
              svelte.enable = false; # Svelte
              vuels.enable = false; # Vue
              pyright.enable = true; # Python
              marksman.enable = true; # Markdown
              nil_ls.enable = true; # Nix
              dockerls.enable = true; # Docker
              bashls.enable = true; # Bash
              clangd.enable = true; # C/C++
              csharp_ls.enable = true; # C#
              yamlls.enable = true; # YAML
            };
          };

	  cmp = {
	    enable = true;
	    autoEnableSources = true;

	    settings = {
	      sources = [
		{ name = "nvim_lsp"; }	
	      ];
	      
	      mappings = {
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

	  gitblame.enable = true;
          
	  project-nvim = {
	    enable = true;
	  };

	  telescope = {
	    enable = true;
	  };
	  
	  nvim-tree = {
	    enable = true;
	    
	    autoClose = true;
	    openOnSetup = true;
	  };

	  which-key = {
	    enable = true;
	  };

	  };
	};
     };
}
