require('neo-tree').setup({
    close_if_last_window = true,
    pupup_border_style = "",
    filesystem = {
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_ignored = false,
        },

        follow_current_file = {
            enabled = true,
            leave_dirs_open = true
        },
    },
})


-- open our neo-tree right after the dashboard opened
vim.api.nvim_create_autocmd("User", {
    pattern = "SnacksDashboardOpened",
    callback = function()
        vim.cmd("Neotree show")
    end,
})

-- open the tree if a single file was open
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() > 0 then
            vim.cmd("Neotree show")
        end
    end,
})
