{
  programs.nixvim.plugins = {
    lualine.enable = true; # TODO: configuration?
    colorizer.enable = true;

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

  };
}
