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
          "rust_analyzer",
          "nil_ls",
        },
        handlers = {
          function(server)
            require("lspconfig")[server].setup({})
          end,
        },
      })
    end,
  },
}
