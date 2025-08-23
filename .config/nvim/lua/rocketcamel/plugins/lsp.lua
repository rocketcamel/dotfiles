local function setup_luau()
	require("luau-lsp").setup({
		platform = {
			type = "roblox",
		},
		types = {
			roblox_security_level = "PluginSecurity",
		},
		sourcemap = {
			enabled = true,
			autogenerate = true,
			rojo_project_file = "default.project.json",
			sourcemap_file = "sourcemap.json",
		},
		plugin = {
			enabled = true,
			port = 3667,
		},
		fflags = {
			enable_new_solver = true,
			sync = true,
		},
	})
	vim.lsp.config("luau-lsp", {
		settings = {
			["luau-lsp"] = {
				completion = {
					autocompleteEnd = true,
					imports = {
						enabled = true,
						suggestServices = true,
						suggestRequires = true,
					},
				},
			},
		},
	})
end

local function setup_lua()
	require("lspconfig").lua_ls.setup({
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
			},
		},
	})
end

local function setup_ts()
	require("lspconfig").ts_ls.setup({})
end

local function setup_nix()
	require("lspconfig").nixd.setup({})
end

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
			require("fidget").setup({
				notification = {
					window = {
						winblend = 0,
					},
				},
			})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"lua_ls",
					"luau_lsp",
					"rust_analyzer",
					"tailwindcss",
					"svelte",
					"html",
					"gopls",
					"templ",
				},
				automatic_enable = { exclude = { "luau_lsp", "lua_ls" } },
			})
			setup_luau()
			setup_lua()
			setup_ts()
			setup_nix()
		end,
	},
}
