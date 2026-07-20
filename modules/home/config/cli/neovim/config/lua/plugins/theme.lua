require('catppuccin').setup({
    flavour = "mocha",
    transparent_background = false,

    integrations = {
        treesitter = true,
        treesitter_context = true,
        native_lsp = {
            enabled = true,

            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
            },

            underlines = {
                errors = { "undercurl" },
                hints = { "undercurl" },
                warnings = { "undercurl" },
                information = { "undercurl" },
            },
        },
        blink_cmp = true,
        lsp_trouble = true,
        indent_blankline = {
            enabled = true,
            colored_indent_levels = true,
        },
    },

})

require('lualine').setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_seperators = "",
        section_separators = "",
        disabled_filetypes = {
            statusline = {
                "snacks_dashboard",
                "dashboard",
                "alpha",
            }
        },
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        },
    },
    -- TODO: configure?
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    }

})

require('ibl').setup({
    exclude = {
        filetypes = {
            "help",
            "neo-tree",
            "ToggleTerm",
            "LazyGit",
            "prompt",
            "Trouble",
            "snacks_dashboard",
        },
    },
})

require('todo-comments').setup({})

vim.cmd.colorscheme "catppuccin-nvim"

