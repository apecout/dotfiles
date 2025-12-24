return {
  -- Tes autres plugins ici...

  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000, -- Assure que le thème est chargé en premier
    config = true, -- Active la configuration par défaut du plugin
    opts = {
      -- Options personnalisées (facultatif)
      -- Exemple :
      contrast = "soft", -- ou "soft" pour moins de contraste
      invert_selection = true,
    },
  },

  -- Tes autres plugins ici...
}

