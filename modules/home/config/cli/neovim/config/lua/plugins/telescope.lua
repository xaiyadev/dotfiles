require('telescope').setup({
    defaults = {
        layout_config = {
            prompt_position = "top",
            width = 0.40,
            height = 0.40,
        },
    },

    pickers = {
        find_files = {
            previewer = false,
        },
        live_grep = {
            theme = "dropdown",
        }
    },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>f', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-f>g', builtin.live_grep, { desc = 'Telescope live grep' })
