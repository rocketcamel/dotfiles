return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"j-hui/fidget.nvim",
			"lopi-py/luau-lsp.nvim",
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
						require("luau-lsp").setup({
							fflags = {
								enable_new_solver = true,
							},
							platform = {
								type = "roblox",
							},
							types = {
								roblox_security_level = "PluginSecurity",
							},
						})
					end,
				},
			})
		end,
	},
}
