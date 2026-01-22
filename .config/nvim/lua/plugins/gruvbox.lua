-- local _border = "single"
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
--   vim.lsp.handlers.hover, {
--     border = _border
--   }
-- )
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
--   vim.lsp.handlers.signature_help, {
--     border = _border
--   }
-- )
-- vim.diagnostic.config {
--   float = { border = _border }
-- }

return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  {
    "ellisonleao/gruvbox.nvim",
    config = function()
      local color_white = "#ebdbb2"
      local color_gray = "#a1a1a1"
      local color_black = "#282828"
      local color_bg = "#232323"
      local color_prompt = "#32302f"
      local color_red = "#cc231d"
      local color_yellow = "#d79921"
      local color_green = "#b8bb26"
      local color_orange = "#fe8019"

      require("gruvbox").setup {
        transparent_mode = true,
        overrides = {
          -- Status Line
          NormalFloat = { fg = "#ebdbb2", bg = color_bg },
          FloatBorder = { fg = color_bg, bg = color_bg },
          StatusLine = { fg = "#ebdbb2", bg = color_bg },
          -- Telescope General
          TelescopeNormal = { bg = color_bg, fg = color_white },
          TelescopeSelection = { bg = color_prompt, fg = color_white },
          TelescopeSelectionCaret = { bg = "", fg = color_red },
          TelescopeMultiSelection = { bg = "", fg = color_yellow },
          TelescopeBorder = { bg = color_bg, fg = color_bg },
          TelescopeResultsBorder = { bg = "", fg = "" },
          TelescopePreviewBorder = { bg = "", fg = "" },
          TelescopeMatching = { bg = "", fg = color_orange },
          -- Prompt Section
          TelescopePromptTitle = { bg = color_yellow, fg = color_black },
          TelescopePromptPrefix = { bg = color_red, fg = color_red },
          TelescopePrompt = { bg = color_orange, fg = "" },
          TelescopePromptNormal = { bg = color_prompt, fg = color_white },
          TelescopePromptBorder = { bg = color_prompt, fg = color_prompt },
          -- Preview Section
          TelescopePreviewTitle = { bg = color_green, fg = color_black },
          -- CMP
          CmpPmenu = { bg = color_bg },
          CmpBorder = { fg = color_bg, bg = color_bg },
          CmpDocBorder = { fg = color_bg, bg = color_bg },
          CmpDoc = { bg = color_bg },
          -- Diagnostics
          DiagnosticFloatingError = { bg = color_bg, fg = color_red },
          DiagnosticFloatingWarn = { bg = color_bg, fg = color_orange },
          DiagnosticFloatingInfo = { bg = color_bg, fg = color_yellow },
          DiagnosticFloatingHint = { bg = color_bg, fg = color_white },
          -- Nerdtree and Nvim-Tree
          NERDTreeHelp = { link = "NONE" },
          -- WinBar
          WinBarNC = { bg = color_black, fg = color_gray },
        },
      }
    end,
  },
}
