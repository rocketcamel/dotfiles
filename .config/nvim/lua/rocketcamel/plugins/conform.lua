return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				luau = { "stylua" },
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				json = { "prettierd" },
				tsx = { "prettierd" },
				nix = { "nixfmt" },
				go = { "gofmt" },
				svelte = { "prettierd" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},
}
