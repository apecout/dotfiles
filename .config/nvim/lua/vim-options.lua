vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

-- Numeros de lignes : relatif sauf pour courante
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

