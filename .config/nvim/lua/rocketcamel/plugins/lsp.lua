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
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
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
      vim.keymap.set("n", "ev", function()
        vim.diagnostic.open_float({ border = "rounded" })
      end)
      vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover({ border = "rounded" })
      end)
      vim.keymap.set("i", "<C-s>", function()
        vim.lsp.buf.signature_help({ border = "rounded" })
      end)
      vim.diagnostic.config({ virtual_text = true })
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
