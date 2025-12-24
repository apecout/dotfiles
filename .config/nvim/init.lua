vim.g.mapleader = " " -- Set leader key before Lazy
 
require("apecout.lazy_init")

-- Numéros hybrides : absolu pour la ligne actuelle, relatif pour les autres
vim.opt.number = true
vim.opt.relativenumber = true

-- Désactive le numéro relatif pour la ligne actuelle
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.opt.relativenumber = true
    vim.cmd([[
      augroup NumberToggle
        autocmd!
        autocmd InsertEnter * set norelativenumber
        autocmd InsertLeave * set relativenumber
      augroup END
    ]])
  end,
})

-- GruvBox
vim.cmd("colorscheme gruvbox")

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]
