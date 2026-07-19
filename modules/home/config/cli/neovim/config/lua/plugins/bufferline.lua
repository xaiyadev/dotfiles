require('bufferline').setup({
    options = {
        show_close_icons = false,
        show_buffer_close_icons = false,
        show_buffer_icons = false,
        offsets = {
            {
                filetype = "neo-tree",
                text = "File Browser",
                text_align = "center",
                separator = ""
            }
        },
        left_mouse_command = "buffer %d",
        right_mouse_command = nil,
        mode = "buffers",
        numbers = "none",
        indicator = {
            style = "icon",
            icon = "",
        },
        style = "none",
    }
})

-- buffer next and bufferNext; move through buffers
vim.keymap.set( "n", "<A-l>", "<cmd>bn<cr>")
vim.keymap.set("n", "<A-h>", "<cmd>bN<cr>")

