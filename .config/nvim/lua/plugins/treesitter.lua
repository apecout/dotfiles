-- ~/.config/nvim/lua/apecout/plugins/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- Commande pour mettre à jour les parsers
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects", -- Pour les objets texte (optionnel)
  },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- Liste des langages à installer
      auto_install = true,
      -- Active la coloration syntaxique
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false, -- Désactive la coloration Vim pour éviter les conflits
      },
      -- Active l'indentation basée sur Tree-sitter
      indent = {
        enable = true,
      },
      -- Active les objets texte (optionnel)
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
    })
  end,
}

