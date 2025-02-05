return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"j-hui/fidget.nvim",
		},
		config = function()
			require("mason").setup()
			require("fidget").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"lua_ls",
					"luau_lsp",
					"rust_analyzer",
					"nil_ls",
				},
				handlers = {
					function(server)
						require("lspconfig")[server].setup({})
					end,
					luau_lsp = function()
						require("lspconfig").luau_lsp.setup({
							fflags = {
								enable_new_solver = true,
							},
						})
					end,
				},
			})
		end,
	},
}
