require('blink.cmp').setup({
    keymap = {
        ["<tab>"] = {
            "select_and_accept",
            "snippet_forward",
            "fallback",
        },

        ["<down>"] = { "select_next", "fallback" },
        ["<up>"] = { "select_prev", "fallback" },
    },

    appearance = {},

    list = {
        cycle = {
            from_top = false,
            from_bottom = false,
        },
    },

    completion = {
        menu = {
            scrolloff = 0,
            border = "none",
            draw = {
                padding = 1,
                gap = 1,
            },
            treesitter = { "buffer", "lsp" },
            ghost_text = {
                enabled = true,
            },
        },
    },

    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        signature = {
            enabled = true,
        },
    },

})
