{ 
  pkgs, 
  self, 
  lib, 
  config,
  osConfig,
  inputs,
  ... 
}:
let
  inherit (self.lib.modules) mkPackageOpt;


  inherit (lib) 
    mkIf
    mkDefault
    ;

  cfg = config.sylveon.cli.neovim;
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  options.sylveon.cli.neovim =
    mkPackageOpt pkgs.neovim "vim editor, only better";

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      enableMan = false;

      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

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

        web-devicons.enable = true;
      };
    };

    stylix.targets.nixvim.plugin = "base16-nvim";
  };
}
