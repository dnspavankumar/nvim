vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
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

-- Disable persistent undo (undodir) if you want, but undofile is fine
-- Autosave on InsertLeave, TextChanged, and FocusLost
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost" }, {
  pattern = "*",
  callback = function()
    if vim.bo.modified and vim.bo.modifiable and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

-- Unlock every file for editing (no readonly)
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*",
  callback = function()
    vim.bo.readonly = false
    vim.bo.modifiable = true
  end,
})

vim.filetype.add({
  extension = {
    h = "cpp",
  },
})
