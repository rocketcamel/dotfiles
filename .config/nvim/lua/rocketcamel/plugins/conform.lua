return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				luau = { "stylua" },
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				tsx = { "prettier" },
				nix = { "nixfmt" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},
}
