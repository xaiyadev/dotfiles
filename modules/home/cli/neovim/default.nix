{
  pkgs,
  self,
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (self.lib.modules)
    mkOpt
    ;

  inherit (lib.types)
    bool
    ;

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
    ./visual.nix
    ./sessions.nix
    ./social.nix
  ];

  # Neovim should be used as a lightweigt editor (used for small changes)
  options.sylveon.cli.neovim = {
    enable = mkOpt bool false "vim editor, only better";
    anonymous = mkOpt bool false "If the file data should be anonymous to people (e.g discord rpc)";
  };

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

      plugins = {
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
