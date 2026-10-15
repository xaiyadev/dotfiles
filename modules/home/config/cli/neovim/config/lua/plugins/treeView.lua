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
