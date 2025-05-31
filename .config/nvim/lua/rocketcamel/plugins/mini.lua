return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.fuzzy").setup()
			require("mini.pairs").setup()
			require("mini.comment").setup()
		end,
	},
}
