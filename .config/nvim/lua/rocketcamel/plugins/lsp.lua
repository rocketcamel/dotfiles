return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"j-hui/fidget.nvim",
			"lopi-py/luau-lsp.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
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
					"tailwindcss",
					"svelte",
					"html",
					"gopls",
					"templ",
				},
				automatic_enable = {
					exclude = { "luau_lsp" },
				},
			})
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.config("*", {
				capabilities = capabilities,
			})
			vim.keymap.set("n", "gtd", vim.lsp.buf.definition)
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
}
