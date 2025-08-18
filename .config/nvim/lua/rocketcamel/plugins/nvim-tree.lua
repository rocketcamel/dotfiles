return {
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup({
                view = { width = 30, side = "left" },
                filters = { dotfiles = false },
                update_focused_file = {
                    enable = true,
                    update_cwd = true,
                    ignore_list = {}
                },
                actions = {
                    open_file = {
                        quit_on_open = false,
                        resize_window = true,
                    }
                }
            })
            vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
        end,
    },
}
