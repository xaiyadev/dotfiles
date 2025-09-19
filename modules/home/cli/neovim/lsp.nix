{ pkgs, ... }: {
  programs.nixvim.plugins = {
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
          trigger.show_on_keyboard = true;
          ghost_text.enabled = true;

          list.cycle = {
            from_bottom = false;
            from_top = false;
          };

          menu = {
            scrolloff = 0;
            border = "none";
            draw = {
              padding = 1;
              gap = 1;
              treesitter = [ "lsp" "buffer" ];
            };
          };
        };

        sources = {
          default = [ "lsp" "path" "snippets" "buffer" ];
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

    lsp = {
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
          enable = true;
      
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
      
        ts_ls = {
          enable = true;
          filetypes = [ "ts" "js" ];
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
  };
}
