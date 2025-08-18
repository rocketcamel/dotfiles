return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "LukasPietzschmann/telescope-tabs",
        },
        config = function()
            local telescope = require("telescope")
            local telescope_tabs = require("telescope-tabs")
            local builtin = require("telescope.builtin")
            telescope.setup({
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                    live_grep = {
                        additional_args = function()
                            return {"--hidden"}
                        end
                    },
                },
            })

            telescope.load_extension("telescope-tabs")
            telescope_tabs.setup()
            vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search" })
            vim.keymap.set("n", "<leader>ft", telescope_tabs.list_tabs)
        end,
    },
}
