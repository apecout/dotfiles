-- ~/.config/nvim/lua/apecout/plugins/mason.lua
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    -- Configuration de base de Mason
    require("mason").setup()

    -- Configuration de mason-lspconfig
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "rust_analyzer" },
      automatic_installation = true,
    })

    -- Configuration des serveurs LSP
    vim.api.nvim_create_autocmd("User", {
      pattern = "MasonInstallationCompleted",
      callback = function()
        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Vérifie que le module lspconfig est chargé
        if not lspconfig then
          vim.notify("lspconfig n'est pas chargé correctement.", vim.log.levels.ERROR)
          return
        end

        -- Configuration pour lua_ls
        local _, lua_ls = pcall(require, "lspconfig.lua_ls")
        if lua_ls then
          lspconfig.lua_ls.setup({
            on_attach = function(client, bufnr)
              -- Configurations spécifiques lors de l'attachement du client LSP
            end,
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          })
        else
          vim.notify("lua_ls n'est pas disponible.", vim.log.levels.WARN)
        end

        -- Configuration pour rust_analyzer
        local _, rust_analyzer = pcall(require, "lspconfig.rust_analyzer")
        if rust_analyzer then
          lspconfig.rust_analyzer.setup({
            on_attach = function(client, bufnr)
              -- Configurations spécifiques lors de l'attachement du client LSP
            end,
            capabilities = capabilities,
          })
        else
          vim.notify("rust_analyzer n'est pas disponible.", vim.log.levels.WARN)
        end
      end,
    })
  end,
}

