local servers = {
  "lua_ls",
  "bashls",
  "jsonls",
  "clangd",
  "yamlls",
}

return {
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = servers
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      for _, server in pairs(servers) do
        lspconfig[server].setup({capabilities = capabilities})
      end
    end,
  },
}
