---@type LazySpec
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      enable_diagnostics = true,
      filesystem = {
        renderers = {
          directory = {
            { "indent" },
            { "icon" },
            { "name" },
            { "diagnostics", errors_only = false, align = "right" },
          },
          file = {
            { "indent" },
            { "icon" },
            { "name" },
            { "diagnostics", align = "right" },
          },
        },
      },
    },
  },
}
