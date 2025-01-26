return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.completion").setup()
			require("mini.fuzzy").setup()
			require("mini.pairs").setup()
		end,
	},
}
