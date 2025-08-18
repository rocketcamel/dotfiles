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
          "nil_ls",
          "tailwindcss",
          "svelte",
          "html",
          "gopls",
          "templ",
        },
        automatic_enable = { exclude = { "luau_lsp" } },
      })
      setup_luau()
    end,
  },
}
