local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8

-- Clipboard & Mouse
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- Backup & Swap files
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Update time
opt.updatetime = 250
opt.timeoutlen = 300

-- Split windows direction
opt.splitright = true
opt.splitbelow = true
