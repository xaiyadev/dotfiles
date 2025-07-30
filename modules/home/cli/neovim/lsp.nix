{ pkgs, ... }: {
  programs.nixvim.plugins.lsp = {
    enable = true;

    servers = {
      dockerls.enable = true;
      bashls.enable = true;
      cssls.enable = true;

      twiggy_language_server = {
        enable  = true;
        package = pkgs.twig-language-server; # https://github.com/nixos/nixpkgs/issues/425846
        cmd = [ "${pkgs.twig-language-server}/bin/twig-language-server" ];
      };

      emmet_language_server = {
        filetypes = [
          "css"
          "html"
          "javascript"
          "javascriptreact"
          "less"
          "sass"
          "scss"
          "typescriptreact"
        ];
      };

      html.enable = true;

      intelephense = {
        enable = true;
        package = pkgs.intelephense;
      };

      jqls.enable = true;
      jsonls.enable = true;
      lua_ls.enable = true;

      nil_ls = {
        enable = true;
        cmd = [ "${pkgs.nil}/bin/nil" ];
        settings = {
          formatting.command = [ "nix fmt" ];
          nix.maxMemoryMB = null;
        };
      };

      vuels = {
        enable = true;
        package = pkgs.vue-language-server;
        cmd = [ "${pkgs.vue-language-server}/bin/vue-language-server" ];
      };
    };
  };
}
