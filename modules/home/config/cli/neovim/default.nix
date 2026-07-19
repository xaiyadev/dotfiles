{ osConfig, lib, pkgs, config, ... }:
let
  inherit (lib) mkIf fileContents mkEnableOption;
in
{

  options.sylveon.programs.neovim.enable = mkEnableOption "Neovim with configuration";

  config = mkIf config.sylveon.programs.neovim.enable {
    xdg.configFile."nvim".source = ./config;

    programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;

      withRuby = false;
      withPython3 = false;

      plugins = [
        pkgs.vimPlugins.nvim-lspconfig # LSP
        pkgs.vimPlugins.neo-tree-nvim # tree-view
        pkgs.vimPlugins.bufferline-nvim # bufferline (tabs)
        pkgs.vimPlugins.snacks-nvim # QoL plugins
        pkgs.vimPlugins.telescope-nvim # Telescope
        pkgs.vimPlugins.cord-nvim # discord integration
      ];

      extraPackages = [
        # specific language servers
        pkgs.bash-language-server
        pkgs.vscode-langservers-extracted # HTML/CSS/JSON/ESLint lsp extracted from vscode
        pkgs.dockerfile-language-server
        pkgs.emmet-language-server
        pkgs.lua-language-server
        pkgs.pyright
        # pkgs.stylelint-lsp
        pkgs.typescript-language-server
        pkgs.vue-language-server
        pkgs.yaml-language-server
        pkgs.nil

        # telescope packages
        pkgs.ripgrep
      ];
    };
  };
}
