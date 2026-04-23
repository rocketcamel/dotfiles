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
			-- enable_new_solver = true,
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
						requireStyle = "alwaysAbsolute",
						stringRequires = { enabled = true },
					},
				},
			},
		},
	})
end

local function setup_lua()
	vim.lsp.config("lua_ls", {
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
	vim.lsp.enable("lua_ls")
end

local function setup_ts()
	vim.lsp.enable("ts_ls")
end

local function setup_nix()
	vim.lsp.enable("nixd")
end

local function setup_java()
	vim.lsp.config("jdtls", {
		root_markers = { "mise.toml", ".git", "gradlew", "gradle.properties", "settings.gradle.kts" },
	})
	vim.lsp.enable("jdtls")
end
--
local function setup_svelte()
	vim.lsp.config("svelte", {
		root_dir = require("lspconfig.util").root_pattern("svelte.config.js", "svelte.config.ts", "package.json"),
	})
	vim.lsp.enable("svelte")
end
--
local function setup_qml()
	vim.lsp.enable("qmlls")
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
					"jdtls",
					"clangd",
					"cmake",
					"cssls",
					"qmlls",
					"tofu_ls",
				},
				automatic_enable = { exclude = { "luau_lsp", "lua_ls", "svelte" } },
			})
			setup_luau()
			setup_lua()
			setup_ts()
			setup_nix()
			setup_java()
			setup_svelte()
			setup_qml()
		end,
	},
}
