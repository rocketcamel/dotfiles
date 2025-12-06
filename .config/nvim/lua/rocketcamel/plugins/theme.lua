return {
	{
		"rose-pine/neovim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("rose-pine").setup()
			vim.cmd.colorscheme("rose-pine")
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
		end,
	},
}
