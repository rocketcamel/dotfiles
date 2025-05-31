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
			telescope.load_extension("telescope-tabs")
			telescope_tabs.setup()
			vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
			vim.keymap.set("n", "<C-p>", builtin.git_files, {})
			vim.keymap.set("n", "<leader>pb", builtin.buffers)
			vim.keymap.set("n", "<leader>ps", builtin.live_grep)
			vim.keymap.set("n", "<leader>pt", telescope_tabs.list_tabs)
		end,
	},
}
