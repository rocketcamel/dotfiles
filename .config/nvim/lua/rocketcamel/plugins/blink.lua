local function setup_keybinds()
	vim.keymap.set("n", "gd", vim.lsp.buf.definition)
	vim.keymap.set("n", "ev", function()
		vim.diagnostic.open_float()
	end)
	-- vim.keymap.set("i", "<C-s>", function()
	-- 	vim.lsp.buf.signature_help()
	-- end)
	vim.diagnostic.config({ virtual_text = true })
end

return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"saghen/blink.lib",
			"rafamadriz/friendly-snippets",
			"L3MON4D3/LuaSnip",
		},
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "enter",
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = {
					-- auto_show = false,
					-- auto_show_delay_ms = 200,
				},
			},
			signature = {
				enabled = true,
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			snippets = {
				preset = "luasnip",
			},
			cmdline = {
				enabled = true,
				sources = function()
					local type = vim.fn.getcmdtype()
					if type == "/" or type == "?" then
						return { "buffer" }
					end
					if type == ":" then
						return { "cmdline", "path" }
					end
					return {}
				end,
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
			},
		},
		config = function(_, opts)
			require("blink.cmp").setup(opts)

			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			setup_keybinds()
		end,
	},
}
