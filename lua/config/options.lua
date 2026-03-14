vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.termguicolors = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 200
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.completeopt = { "menu", "menuone", "noselect" }
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.fillchars:append({ eob = "~" })

vim.filetype.add({
  extension = {
    h = "cpp",
  },
})
