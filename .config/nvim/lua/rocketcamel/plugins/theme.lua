return {
	{
		"rose-pine/neovim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("rose-pine").setup({
				styles = {
					transparency = true,
				},
			})
			vim.cmd("colorscheme rose-pine")
		end,
	},
}
