-- ~/.config/nvim/lua/apecout/plugins/cmp.lua
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- Source LSP pour nvim-cmp
    "hrsh7th/cmp-buffer",   -- Source pour les mots du buffer
    "hrsh7th/cmp-path",     -- Source pour les chemins de fichiers
    "hrsh7th/cmp-cmdline",  -- Source pour la ligne de commande
    "L3MON4D3/LuaSnip",     -- Snippets (optionnel)
    "saadparwaiz1/cmp_luasnip", -- Intégration de LuaSnip avec nvim-cmp
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
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
        { name = "buffer" },
        { name = "path" },
      }),
    })
  end,
}

