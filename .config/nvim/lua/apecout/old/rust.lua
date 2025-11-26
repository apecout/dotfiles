-- ~/.config/nvim/lua/apecout/plugins/rust.lua
return {
  "simrat39/rust-tools.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    local rt = require("rust-tools")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    rt.setup({
      server = {
        on_attach = function(_, bufnr)
          -- Keymaps ou configurations spécifiques
        end,
        capabilities = capabilities,
      },
      tools = {
        -- Options pour les outils de rust-tools
      },
    })
  end,
}

