{ lib, config, ... }:
let
  inherit (lib) mkMerge mkIf;

  cfg = config.sylveon.cli.neovim;
in
{
  programs.nixvim.plugins = {
    cord = {
      enable = true; # TODO: disable for blmedia account

      settings = {
        display = {
          swap_fields = true;

          theme = "atom";
          flavor = "accent";
        };

        timestamp.shared = true;

        editor = {
          tooltip = "NixOS managed VIM";
          icon = "https://raw.githubusercontent.com/IogaMaster/neovim/main/.github/assets/nixvim-dark.webp";
        };

        text = (if cfg.anonymous then {
          file_browser = ''Browsing through ***'';
          workspace = ''In ***'';
          viewing = ''Viewing ***'';
          lsp = ''Configuring LSP'';
          docs = ''Reading ***'';
          vsc = ''Committing changes in ***'';
          notes = ''Taking notes in ***'';
          debug = ''Debugging in ***'';
          test = ''Testing in ***'';
          diagnostics = ''Fixing problems in ***'';
          games = ''Playing ***'';
          terminal = ''Running commands in ***'';

          editing.__raw = ''
            function(opts)
              return string.format('Editing ***.%s', opts.filetype)
            end
          '';

        } else {
          file_browser.__raw = ''
            function(opts)
              return string.format('Browsing through %s', opts.workspace)
            end
          '';
        });
      };
    };
  };
}
